cat("Visualizing data")

# Misc bits of text to accompany graphics
source(dir_src("visualize_strings.R"))

################################################################################
# Individual visualizations
################################################################################
# Overall COVID-19 status
source(dir_src("visualize_daily_case_status.R"))

# New daily cases and tests + per 100K cases
source(dir_src("visualize_new_daily_cases_avg.R"))
source(dir_src("visualize_new_daily_cases_100K.R"))
source(dir_src("visualize_new_daily_tests_avg.R"))

# Deaths
source(dir_src("visualize_new_daily_deaths.R"))
source(dir_src("visualize_mb_deaths.R"))

# Hospitalizations
source(dir_src("visualize_daily_hospitalization.R"))
# source(dir_src("visualize_daily_hospitalization_total.R"))

# Test positivity
source(dir_src("visualize_test_positivity.R"))

# RHA new, active and total cases + 100K
source(dir_src("visualize_rha_new_cases.R"))
source(dir_src("visualize_rha_new_case_100K.R"))

source(dir_src("visualize_rha_active_cases.R"))
source(dir_src("visualize_rha_active_case_100K.R"))

source(dir_src("visualize_rha_total_cases.R"))
source(dir_src("visualize_rha_total_case_100K.R"))

# Health district snapshot
source(dir_src("visualize_district_active_cases.R"))
source(dir_src("visualize_district_active_case_100K.R"))
# source(dir_src("visualize_districts_new_cases.R"))

# TODO WIP Weekly pct change in cases and deaths
# source(dir_src("visualize_cases_deaths_week_over_week.R"))

# COVID-19 variants
source(dir_src("visualize_variants.R"))
source(dir_src("visualize_variant_of_concern_status.R"))

################################################################################
# PHAC Total cases and deaths per 100K people
################################################################################
source(dir_src("visualize_phac_new_7day_case_100K.R"))
source(dir_src("visualize_phac_active_case_100K.R"))
source(dir_src("visualize_phac_total_case_100K.R"))
source(dir_src("visualize_phac_total_deaths_100K.R"))
source(dir_src("visualize_phac_14day_new_cases_100K.R"))
source(dir_src("visualize_phac_growth_since_10th.R"))



################################################################################
# Vaccinations
################################################################################
source(dir_src("visualize_vaccine_admin_gap.R"))
source(dir_src("visualize_vaccine_daily_vaccinations.R"))
source(dir_src("visualize_vaccine_demographics.R"))
source(dir_src("visualize_vaccine_distribution.R"))
source(dir_src("visualize_vaccine_first_second_dose.R"))
source(dir_src("visualize_vaccine_gap_provinces.R"))
source(dir_src("visualize_vaccine_targets.R"))
source(dir_src("visualize_vaccine_demographic_coverage.R"))
# source(dir_src("_scratch", "visualize_vaccine_demographics_female_male.R"))
# source(dir_src("_scratch", "visualize_vaccine_distribution.R"))
# source(dir_src("_scratch", "visualize_vaccine_administration.R"))
source(dir_src("visualize_vaccine_uptake.R"))

################################################################################
# Weekly epi report
################################################################################
source(dir_src("visualize_transmission_source.R"))
source(dir_src("visualize_healthcareworkers.R"))
source(dir_src("visualize_symptoms.R"))


# Vaccine comparison using data from
# COVID-19 Canada Open Data Working Group
source(dir_src("_provincial_vaccine_comparison.R"))


cat("DONE: Visualizing data")
cat(" ")
cat(" ")
