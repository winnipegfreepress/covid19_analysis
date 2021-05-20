
# View(wfp_daily_totals)


bulletin_weekly <- wfp_daily_totals %>%
  mutate(
    iso_week = isoweek(date),
    iso_year = isoyear(date),
    epi_week = epiweek(date),
    epi_year = epiyear(date),
  ) %>%
  mutate(
    new_daily_cases = ifelse(is.na(new_daily_cases), 0, new_daily_cases)
  ) %>%
  select(
    date, iso_week, iso_year, epi_week, epi_year, new_daily_cases
  )

bulletin_weekly_total_cases <- bulletin_weekly %>%
  group_by(
    epi_week, epi_year
  ) %>%
  summarise(
    iso_week_sum_bulletin = sum(new_daily_cases, rm.na=TRUE)
  )



dashboard_daily_status_all <- dashboard_daily_status_all %>%
  mutate(
    iso_week = isoweek(date),
    iso_year = isoyear(date),
    epi_week = epiweek(date),
    epi_year = epiyear(date),
  )


dashboard_weekly_total_cases <- dashboard_daily_status_all %>%
  select(date, daily_cases) %>%
  mutate(
    iso_week = isoweek(date),
    iso_year = isoyear(date),
    epi_week = epiweek(date),
    epi_year = epiyear(date),
  ) %>%
  mutate(
    new_daily_cases = ifelse(is.na(daily_cases), 0, daily_cases)
  ) %>%
  group_by(
    epi_week, epi_year
  ) %>%
  summarise(
    iso_week_sum_dashboard = sum(new_daily_cases, rm.na=TRUE)
  )


View(bulletin_weekly_total_cases)
View(dashboard_weekly_total_cases)
