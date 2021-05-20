# Pulled values for total and 18+ populations
population_manitoba_2020 <- population_provinces_2020 %>% filter(province =="Manitoba") %>% select(population) %>% pull()

population_manitoba_18plus_2021Q2 <- read_csv(dir_data_raw("population_provinces_18plus_2021Q2.csv")) %>%
  clean_names() %>%
  rename(
    province=geography,
    population=population_18plus_2020q2
  ) %>%
  mutate(reference_period=as.Date("2020-06-30")) %>%
  select("reference_period", "province", "population") %>%
  filter(province=="Manitoba") %>%
  pull()



wfp_covid19_topline <- wfp_daily_totals %>%
# left_join(
#   (dashboard_daily_status_all %>%
#       rename_all( list(~paste0(., "__dashb")))
#   ),
#   by=c("date"="date")
# ) %>%
left_join(
  COVID19_MB_first_second_vaccine_dose,
  by=c("date"="vaccination_date")
) %>%
left_join(
    COVID19_MB_vaccine_distribution %>% filter(province=="Manitoba"),
    by=c("date"="date")
) %>%
fill(
  first_doses,
  second_doses,
  total_doses,
  cumulative_first_doses,
  cumulative_second_doses,
  cumulative_total_doses,
  cumulative_dvaccine
) %>%
mutate(
  epi_week = epiweek(date),
  year=year(date),
  epi_week_year=paste(year, "-", epi_week, sep=""),
  population_2020=population_manitoba_2020,
  population_2020_18plus=population_manitoba_18plus_2021Q2,
  # new_daily_deaths=deaths - lag(deaths),
  new_daily_cases=ifelse(is.na(new_daily_cases), 0, new_daily_cases),
  new_daily_deaths=ifelse(is.na(new_daily_deaths), 0, new_daily_deaths),
  cases_14day_sum=roll_sumr(new_daily_cases, n=14),
  cases_14day_100K=cases_14day_sum/population_manitoba_2020 * 100000,
  deaths_14day_sum=roll_sumr(new_daily_deaths, n=14),
  doses_first_14day_sum=roll_sumr(first_doses, n=14),
  cases_14day_pctchg=((cases_14day_sum - lag(cases_14day_sum)) / lag(cases_14day_sum)) * 100,
  deaths_14day_pctchg=((deaths_14day_sum - lag(deaths_14day_sum)) / lag(deaths_14day_sum)) * 100,
  doses_first_14day_pctchg=((doses_first_14day_sum - lag(doses_first_14day_sum)) / lag(doses_first_14day_sum)) * 100,
  cumulative_first_doses_per_100K=cumulative_first_doses / population_2020_18plus * 100000
)
