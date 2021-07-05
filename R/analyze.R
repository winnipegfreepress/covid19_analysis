
################################################################################
# WFP Tracker
################################################################################
wfp_daily_totals <- read_feather(dir_data_processed("wfp_daily_totals.feather"))

wfp_daily_status_tall <-  wfp_daily_totals %>%
  filter(!is.na(date)) %>%
  select(date, active, recovered, deaths) %>%
  mutate(
    active = as.numeric(as.character(active))
  ) %>%
  fill(active, recovered, deaths) %>%
  pivot_longer(-date, names_to="type", values_to="cnt") %>%
  mutate(type=factor(type, levels=c("deaths", "recovered", "active")))

wfp_daily_hospitalization_tall <-  wfp_daily_totals %>%
  select(date, active_icu, active_non_icu) %>%
  fill(active_icu, active_non_icu) %>%
  pivot_longer(-date, names_to="type", values_to="cnt") %>%
  mutate(
    type=ifelse(type=="active_icu", "ICU", "Non-ICU"),
    type=factor(type, levels=c("Non-ICU", "ICU"))
  )

wfp_daily_hospitalization_total_active_tall <-  wfp_daily_totals %>%
  select(date, active_icu, active_hospital, total_hospital, total_icu) %>%
  fill(active_icu, active_hospital, total_hospital, total_icu) %>%
  mutate(
    inactive_hospital = total_hospital - active_hospital - active_icu,
    inactive_icu = total_icu - active_icu
  ) %>%
  select(-total_hospital, -total_icu) %>%
  pivot_longer(-date, names_to="type", values_to="cnt") %>%
  mutate(
    type=ifelse(type=="active_icu", "ICU (active)",
                  ifelse(type=="active_hospital", "Non-ICU (active)",
                  ifelse(type=="inactive_icu", "ICU (inactive)",
                  ifelse(type=="inactive_hospital", "Non-ICU (inactive)",
                  type)))),
    type=factor(type, levels=c("Non-ICU (inactive)", "Non-ICU (active)", "ICU (inactive)", "ICU (active)")),
    cnt=ifelse(is.na(cnt), 0, cnt)
  )


wfp_daily_hospitalization_totals <- wfp_daily_totals %>%
  select(
    date, total_hospital, total_icu, active_hospital, active_icu
  ) %>%
  mutate(
    total_non_icu = total_hospital - total_icu,
    active_non_icu = active_hospital - active_icu,
    inactive_hospital = total_hospital - active_hospital,
    inactive_icu = total_icu - active_icu,
    inactive_non_icu = total_non_icu - active_non_icu
  ) %>%
  select(
    date,
    total_hospital,
    total_icu,
    total_non_icu,
    active_hospital,
    active_icu,
    active_non_icu,
    inactive_hospital,
    inactive_non_icu
  )


################################################################################
# Five-day positivity
################################################################################
dashboard_5day_positivity <- read_feather(dir_data_processed("dashboard_5day_positivity.feather"))



################################################################################
# Manitoba combined RHAs
################################################################################
dashboard_daily_status_all <- read_feather(dir_data_processed("dashboard_daily_status_all.feather"))


################################################################################
# RHA
################################################################################
dashboard_daily_status_manitoba <- read_feather(dir_data_processed("dashboard_daily_status_manitoba.feather"))


################################################################################
# Health district daily snapshot
################################################################################
dashboard_daily_status_districts_all <- read_feather(dir_data_processed("dashboard_daily_status_districts_all.feather"))


################################################################################
# Public Health Agency of Canada
################################################################################
phac_daily <- read_feather(dir_data_processed("phac_daily.feather"))


################################################################################
# COVID-19 variants
################################################################################
covid19_variants <- read_feather(dir_data_processed("covid19_variants.feather"))
dashboard_variants_of_concern <- read_feather(dir_data_processed("dashboard_variants_of_concern.feather"))


################################################################################
# Weekly epidemiology report
################################################################################
wfp_healthcareworkers_tall <- read_feather(dir_data_processed("gsheet_wfp_healthcareworkers.feather"))
wfp_healthcareworkers_tall <- read_feather(dir_data_processed("gsheet_wfp_healthcareworkers_tall.feather"))

wfp_transmission_source.feather <- read_feather(dir_data_processed("gsheet_wfp_transmission_source.feather"))
wfp_transmission_source_tall <- read_feather(dir_data_processed("gsheet_wfp_transmission_source_tall.feather"))

wfp_symptoms <- read_feather(dir_data_processed("gsheet_wfp_symptoms.feather"))
wfp_symptoms_tall <- read_feather(dir_data_processed("gsheet_wfp_symptoms_tall.feather"))


population_provinces_2020 <-  read_feather(dir_data_processed("population_provinces_2020.feather"))
population_manitoba_2020 <- population_provinces_2020 %>% filter(province =="Manitoba") %>% select(population) %>% pull()
manitoba_health_regions_populations <-  read_feather(dir_data_processed("manitoba_health_regions_populations.feather"))
manitoba_health_districts_populations <-  read_feather(dir_data_processed("manitoba_health_districts_populations.feather"))
MB_age_group_pops <-  read_feather(dir_data_processed("MB_age_group_pops.feather"))
MB_pop_estimates_2020_statcan_17_10_0005_01 <-  read_feather(dir_data_processed("MB_pop_estimates_2020_statcan_17_10_0005_01.feather"))
population_provinces_18plus_2021Q2 <-  read_feather(dir_data_processed("population_provinces_18plus_2021Q2.feather"))

mbhealth_population_age_20200601 <- read_feather(dir_data_processed("mbhealth_population_age_20200601.feather"))
mbhealth_population_agegroups <-read_feather(dir_data_processed("mbhealth_population_agegroups.feather"))
mbhealth_population_agegroups_12plus <- read_feather(dir_data_processed("mbhealth_population_agegroups_12plus.feather"))
population_12plus_total <- sum(mbhealth_population_agegroups_12plus$population_age)

################################################################################
# Growth in provincial cases since the 10th case
################################################################################
source(dir_src("analyze_provincial_case_growth.R"))


################################################################################
# Weekly cases and deaths as abs and pct chg
################################################################################
source(dir_src("analyze_weekly_cases_deaths.R"))

################################################################################
# Vaccinations
################################################################################
source(dir_src("analyze_vaccinations.R"))

################################################################################
# Districts
################################################################################
source(dir_src("analyze_districts.R"))

################################################################################
# Topline blocks
################################################################################
source(dir_src("analyze_topline_blocks.R"))
