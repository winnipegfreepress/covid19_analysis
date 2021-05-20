
dashboard_weekly_dates <- dashboard_daily_status_all %>%
  mutate(
    year=year(date),
    week_year=paste(epi_week, "-", year, sep="")
  ) %>%
  select(date, week_year)


dashboard_daily_status_all_weekly_cases <- dashboard_daily_status_all %>%
  mutate(
    year=year(date),
    week_year=paste(epi_week, "-", year, sep="")
  ) %>%
  group_by(
    week_year
  ) %>%
  summarise(
    epi_cases=sum(daily_cases)
  )

dashboard_daily_status_all_weekly_deaths <- dashboard_daily_status_all %>%
  arrange(date) %>%
  mutate(
    daily_deaths=deaths - lag(deaths),
    year=year(date),
    week_year=paste(epi_week, "-", year, sep="")
  ) %>%
  group_by(
    week_year
  ) %>%
  summarise(
    epi_deaths=sum(daily_deaths)
  )



# View(dashboard_daily_status_all_weekly_cases)
# View(dashboard_daily_status_all_weekly_deaths)


dashboard_weekly_cases_deaths <- left_join(
  dashboard_weekly_dates,
  dashboard_daily_status_all_weekly_cases,
  by=c("week_year"="week_year")
) %>%
  left_join(
    dashboard_daily_status_all_weekly_deaths,
    by=c("week_year"="week_year")
  ) %>%
  arrange(date) %>%
  mutate(
    weekly_cases_pct_change=(epi_cases - lag(epi_cases)) / abs(lag(epi_cases)) * 100,
    weekly_deaths_pct_change=(epi_deaths - lag(epi_deaths)) / abs(lag(epi_deaths)) * 100
  ) %>%
  mutate(
    weekly_cases_pct_change=ifelse(weekly_cases_pct_change == 0, NA, weekly_cases_pct_change),
    weekly_deaths_pct_change=ifelse(weekly_deaths_pct_change == 0, NA, weekly_deaths_pct_change)
  )

