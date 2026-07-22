# Load required libraries
library(tidyverse)
library(here)
library(readxl)

# Read CSV file
df <- read_csv(here('data', 'raw', 'Extraction form (Responses) - Form Responses 1.csv'))

# Sanitize column names
colnames(df) <- tolower(gsub(" ", ".", colnames(df)))

# Rename key columns
df <- df %>%
  rename(
    coder = `coder.initials`,
    article_id = article.id
  ) %>%
  rename( # standardize column names for copy paste columns
    prereg_verbatim = `copy.and.paste.the.verbatim.statement`,
    data_verbatim = `copy.and.paste.the.verbatim.statement.(if.there.is.one)`,
    data_reasons_verbatim = `copy.and.paste.the.verbatim.reasons.(if.any)`,
    materials_verbatim = `copy.and.paste.the.verbatim.statement(s).(if.there.are.any).`,
    materials_reasons_verbatim = `copy.and.paste.the.verbatim.reasons.(if.any)....26`,
    analysis_verbatim = `copy.and.paste.the.verbatim.statement.(if.any).`,
    analysis_reasons_verbatim = `copy.and.paste.the.verbatim.reasons.(if.any)....32`,
    reporting_verbatim = `copy.and.paste.the.reporting.guideline.statement.verbatim.(if.any)`,
    funding_verbatim = `copy.and.paste.the.verbatim.statement....37`,
    coi_verbatim = `copy.and.paste.the.verbatim.statement....39`
  )
  

# let's also pull in the consensus pilot data (coding performed by IGL and TEH) so we can compare that to JB's coding
df_pilot <- read_excel(here('data', 'raw', 'pilot', 'pilot_comparison_resolved.xlsx')) %>% 
  filter(coder == "Consensus") %>%
  mutate(coder = "Pilot") %>%
  select(-starts_with("how.did.you.identify"), -starts_with("what.is.the.source")) %>% # remove columns we didn't use after pilot
  rename( # standardize column names for copy paste columns
    prereg_verbatim = `copy.and.paste.the.verbatim.statement`,
    data_verbatim = `copy.and.paste.the.verbatim.statement.(if.there.is.one)`,
    data_reasons_verbatim = `copy.and.paste.the.verbatim.reasons.(if.any)`,
    materials_verbatim = `copy.and.paste.the.verbatim.statement(s).(if.there.are.any).`,
    materials_reasons_verbatim = `copy.and.paste.the.verbatim.reasons.(if.any)....30`,
    analysis_verbatim = `copy.and.paste.the.verbatim.statement.(if.any).`,
    analysis_reasons_verbatim = `copy.and.paste.the.verbatim.reasons.(if.any)....37`,
    reporting_verbatim = `copy.and.paste.the.reporting.guideline.statement.verbatim.(if.any)`,
    funding_verbatim = `copy.and.paste.the.verbatim.statement....43`,
    coi_verbatim = `copy.and.paste.the.verbatim.statement....46`
  )

# combine the pilot and main datasets
df <- bind_rows(df, df_pilot)

# define coder status
df <- df %>%
  mutate(coder_type = ifelse(coder == "JB", "Primary", "Secondary"))

# Identify the coders
coders <- unique(df$coder_type)

# Check exactly two coders
if (length(coders) != 2) {
  stop("There must be exactly two coders. Found: ", paste(coders, collapse = ", "))
}

# Create initial consensus rows based on primary coder
consensus_rows <- df %>%
  filter(coder_type == "Primary") %>%
  mutate(
    coder = "Consensus",
    coder_type = "Consensus",
    timestamp = "None"
  )

# Combine original and consensus data
df_extended <- bind_rows(df, consensus_rows)

# Set factor level for consistent ordering
df_extended$coder_type <- factor(df_extended$coder_type, levels = c("Primary", "Secondary", "Consensus"))

# Sort rows by article ID and coder type
df_extended <- df_extended %>%
  arrange(article_id, coder_type) %>%
  select(article_id, coder, coder_type, everything()) %>%
  select(-timestamp, timestamp)

# Define columns to use for the comparison (excluding those starting with "copy.and.paste")
cols_to_compare <- df %>%
  select(
    -timestamp,
    -coder,
    -coder_type,
    -article_id,
    -ends_with("_verbatim"),
    -ends_with("_reasons")
  ) %>%
  colnames()

# Create Excel workbook
wb <- createWorkbook()
addWorksheet(wb, "Comparison")
freezePane(wb, "Comparison", firstActiveRow = 2)

# Write column headers (once)
writeData(wb, "Comparison", df_extended[0, ], startRow = 1, colNames = TRUE)

# Start writing article data from row 2
row_idx <- 2

# Loop through each article
for (id in unique(df_extended$article_id)) {
  article_data <- df_extended %>% filter(article_id == id)
  
  # Safety check
  if (nrow(article_data) != 3) {
    warning(paste("Skipping article ID", id, "- expected 3 rows, found", nrow(article_data)))
    next
  }
  
  # Write article data
  writeData(wb, "Comparison", article_data, startRow = row_idx, colNames = FALSE)
  
  # Compare coder rows (exclude Consensus)
  coder_rows <- article_data %>% filter(coder != "Consensus")
  
  for (col_name in cols_to_compare) {
    val1 <- coder_rows[[1, col_name]]
    val2 <- coder_rows[[2, col_name]]
    
    if (!identical(val1, val2)) {
      # Get Excel column index
      col_index <- which(names(df_extended) == col_name)
      
      # Create yellow highlight style
      highlight_style <- createStyle(fgFill = "#FFFF00")
      
      # Apply highlight to consensus row
      addStyle(wb, "Comparison", highlight_style,
               rows = row_idx + 2, cols = col_index, gridExpand = TRUE)
    }
  }
  
  # Move to next article (3 rows per article)
  row_idx <- row_idx + 3
}

# Save the workbook to specified path
output_path <- here("data", "primary", "extracted_data_comparison.xlsx")
saveWorkbook(wb, output_path, overwrite = TRUE)

cat("✅ Export complete:", output_path, "\n")
