This folder contains three data files.

# article_list.csv 

Contains a list of the 271 articles we identified in the Haidt et al. (2025) collaborative review document (https://tinyurl.com/SocialMediaMentalHealthReview). We downloaded the document on 24th May 2025.

Columns:
article_id: a unique ID code so we can keep track of articles across datasets
authors: the article authors
publication_year: year article was published
DOI: digital object identifier	
title: article title	
journal: journal the article is published in
section_in_doc: the section of the collaborative review document that the article was in	
duplicate: whether the article appears more than once in the document (T = TRUE i.e., yes it does and F = FALSE i.e., no it doesn't).


# extracted_data_comparison.xlsx 

Created by running the script coder_differences_main.R on the raw data downloaded from Google Drive. The raw data files contains the coding by IGL and JB, so each article has two rows. The script creates a third "consensus" row for each article, but initially this is just a copy of the primary coder's coding. The script checks IGL vs JB coding and highlights cells that are different. The script also sanitises some column names to make them easier to work with.

Columns:
article_id: a unique ID code so we can keep track of articles across datasets
coder: initials of the person who did the coding	
coder_type: primary (first) or secondary (second) coder

The columns below map on to the extraction form and are self-explanatory (aside for the columns ending in _verbatim — these contain verbatim information from articles to support the coding process):
	
is.the.article.reported.in.a.peer-reviewed.academic.journal?	

is.the.article.written.in.english?	

can.you.view.an.open.access.version.of.this.article?	

which.version.of.the.article.are.you.coding?	

does.the.article.report.empirical.research?	

what.is.the.research.design?.(tick.all.that.apply)	

what.is.the.data.type?.(tick.all.that.apply	

does.the.article.state.whether.or.not.the.study.(or.some.aspect.of.the.study).was.preregistered?

prereg_verbatim	

how.is.the.preregistration.accessed?.(according.to.the.statement)

can.you.access.and.view.the.preregistration.(without.contacting.anyone)?

does.the.article.state.whether.or.not.data.are.available?	

data_verbatim	

how.are.the.data.accessed?.(according.to.the.statement)	

can.you.access,.download,.and.view.the.data.(without.contacting.anyone)?	

did.the.authors.provide.any.reasons.for.not.sharing.or.restricting.access.to.the.data?	

data_reasons_verbatim	

does.the.article.state.whether.or.not.any.materials.are.available?	

materials_verbatim	

how.are.the.materials.accessed?.(according.to.the.statement)	

can.you.access,.download,.and.view.the.materials.(without.contacting.anyone)?	

did.the.authors.provide.any.reasons.for.not.sharing.or.restricting.access.to.the.materials?	

materials_reasons_verbatim	

does.the.article.state.whether.or.not.analysis.scripts.are.available?	

analysis_verbatim	

how.is.the.analysis.script.accessed?.(according.to.the.statement)	

can.you.access,.download,.and.view.the.analysis.script.(without.contacting.anyone)?	

did.the.authors.provide.any.reasons.for.not.sharing.or.restricting.access.to.the.analysis.scripts?	

analysis_reasons_verbatim	

is.there.a.statement.declaring.the.use.of.one.or.more.reporting.guidelines?	

reporting_verbatim	

which.guidelines.were.used.(if.any)?.(select.all.that.apply.and.use.the.other.option.if.necessary)	

does.the.article.include.a.statement.indicating.whether.there.were.funding.sources?	

funding_verbatim	

does.the.article.include.a.statement.indicating.whether.there.were.any.conflicts.of.interest?	

coi_verbatim	

you.can.use.this.space.to.record.anything.interesting.or.problematic.about.this.article	

timestamp: the time that the data was recorded.

# extracted_data_resolved.csv 

Created by initially duplicating extracted_data_comparison.xlsx. TEH then worked through the coding discrepancies (highlighted in yellow) and manually resolved them in the rows with "Consensus" in the coder column so that eventually the consensus row represented the finalised coding to be used in the main data analysis.