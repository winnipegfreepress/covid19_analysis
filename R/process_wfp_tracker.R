
wfp_daily_totals_raw <- read_csv(dir_data_raw("gsheet_wfp_daily_totals.csv")) %>%
  clean_names() %>%
  filter(!is.na(date)) %>%
  fill(deaths) %>%
  mutate(
    date=as.Date(date, "%m/%d/%Y"),
    new_daily_cases=as.numeric(as.character(new_daily_cases)),
    new_daily_tests=test_daily_diff,
    new_daily_deaths=new_daily_deaths,
    cases_mavg_7day=roll_mean(new_daily_cases, 7, na.rm=TRUE, fill=NA, align="right"),
    tests_mavg_7day=roll_mean(new_daily_tests, 7, na.rm=TRUE, fill=NA, align="right"),
    hospital_total_mavg_7day=roll_mean(total_hospital, 7, na.rm=TRUE, fill=NA, align="right"),
    icu_total_mavg_7day=roll_mean(total_icu, 7, na.rm=TRUE, fill=NA, align="right"),
    hospital_active_mavg_7day=roll_mean(active_hospital, 7, na.rm=TRUE, fill=NA, align="right"),
    icu_active_mavg_7day=roll_mean(active_icu, 7, na.rm=TRUE, fill=NA, align="right"),
    deaths_mavg_7day=roll_mean(new_daily_deaths, 7, na.rm=TRUE, fill=NA, align="right"),
    new_daily_cases_100K=new_daily_cases / population_manitoba_2020 * 100000,
    new_7day_cases_100K=(roll_sum(new_daily_cases, 7, na.rm=TRUE, fill=NA, align="right") / 7) / population_manitoba_2020 * 100000
  )


wfp_test_positivity_ywg <- read_csv(dir_data_raw("gsheet_wfp_test_positivity.csv"))



write_feather(wfp_daily_totals_raw, dir_data_processed("wfp_daily_totals.feather"))
write_csv(wfp_daily_totals_raw, dir_data_processed("wfp_daily_totals.csv"))
