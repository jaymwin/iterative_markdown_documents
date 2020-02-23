
# packages
library(knitr)
library(rmarkdown)
library(tidyverse)
library(readxl)
library(janitor)
library(pdftools)
library(fs)

# data
personalized_info <- read_excel(here::here("reu_filtered.xlsx"))

# clean up column names
personalized_info <- personalized_info %>%
  clean_names()
glimpse(personalized_info)

# grab pertinent info
personalized_info <- personalized_info %>%
  select(
    applicants_first_name,
    applicants_last_name,
    address, 
    prefered_phone_number,
    prefered_email_address,
    gender, 
    citizenship,
    highest_degree_obtained_by_either_parent,
    your_current_academic_institution,
    academic_major,
    academic_minor,
    current_academic_status,
    expected_graduation_date,
    do_you_plan_to_attend_graduate_school,
    i_would_be_most_interested_in_research_experiences,
    do_you_wish_to_live_on_campus_during_the_reu_program_on_campus_housing_will_be_provided_at_no_cost,
    are_you_able_to_begin_research_on_or_near_may_18_2020,
    military_service_i_am_a_veteran_of_military_service_in_the_us_armed_forces,
    race_ethnicity_how_would_you_describe_yourself_please_select_all_that_apply,
    why_do_you_want_to_participate_in_the_reu_raptor_research_program_what_do_you_expect_to_get_out_of_the_program,
    please_describe_any_prior_relevant_experience_e_g_research_laboratory_science_jobs_etc,
    please_provide_any_additional_information_about_you_or_your_career_plans_that_you_would_like_the_selection_committee_to_have
  )
personalized_info

# order by last name of applicant
personalized_info <- personalized_info %>%
  arrange(applicants_last_name)

# loop through each row and create a markdown pdf for each applicant
for (i in 1:nrow(personalized_info)) {
  
  # these are used in the .Rmd file
  first_name <- personalized_info$applicants_first_name[i]
  last_name <- personalized_info$applicants_last_name[i]
  applicant_name <- str_c(personalized_info$applicants_first_name[i], ' ', personalized_info$applicants_last_name[i])
  address <- personalized_info$address[i]
  phone <- personalized_info$prefered_phone_number[i]
  email <- personalized_info$prefered_email_address[i]
  gender <- personalized_info$gender[i] 
  citizenship <- personalized_info$citizenship[i]
  parent_degree <- personalized_info$highest_degree_obtained_by_either_parent[i]
  current_inst <- personalized_info$your_current_academic_institution[i]
  major <- personalized_info$academic_major[i]
  minor <- personalized_info$academic_minor[i]
  current <- personalized_info$current_academic_status[i]
  grad_date <- personalized_info$expected_graduation_date[i]
  grad_school <- personalized_info$do_you_plan_to_attend_graduate_school[i]
  res_exp <- personalized_info$i_would_be_most_interested_in_research_experiences[i]
  campus <- personalized_info$do_you_wish_to_live_on_campus_during_the_reu_program_on_campus_housing_will_be_provided_at_no_cost[i]
  start <- personalized_info$are_you_able_to_begin_research_on_or_near_may_18_2020[i]
  military <- personalized_info$military_service_i_am_a_veteran_of_military_service_in_the_us_armed_forces[i]
  race <- personalized_info$race_ethnicity_how_would_you_describe_yourself_please_select_all_that_apply[i]
  why <- personalized_info$why_do_you_want_to_participate_in_the_reu_raptor_research_program_what_do_you_expect_to_get_out_of_the_program[i]
  rel_exp <- personalized_info$please_describe_any_prior_relevant_experience_e_g_research_laboratory_science_jobs_etc[i]
  career <- personalized_info$please_provide_any_additional_information_about_you_or_your_career_plans_that_you_would_like_the_selection_committee_to_have[i]
  
  # create each document
  rmarkdown::render(input = "create_markdown_pdfs.Rmd",
                    output_format = "pdf_document",
                    output_file = paste(last_name, '_', first_name, '_', 'reu_application', ".pdf", sep=''),
                    output_dir = here::here()
                    )
  
}

# bind them all together into one document
pdf_list <- dir_ls(here::here(), glob = '*pdf')
pdf_combine(pdf_list, output = "2020_reu_applications.pdf")
