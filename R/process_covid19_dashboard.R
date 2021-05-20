
################################################################################
# Five-day test positivity for Manitoba and Winnipeg
################################################################################
dashboard_5day_positivity_raw <- jsonlite::fromJSON(dir_data_raw('dashboard_5day_positivity.json'))
dashboard_5day_positivity_raw <- dashboard_5day_positivity_raw[["features"]][["attributes"]]
dashboard_5day_positivity_raw <- dashboard_5day_positivity_raw %>%
  clean_names() %>%
    mutate(
      date=as.Date(as.POSIXct(as.integer(as.numeric(as.character(date)) / 1000.0), origin='1970-01-01', tz="GMT"))
    ) %>%
    select(
      -object_id
    ) %>%
    left_join(
      wfp_test_positivity_ywg,
      by=c("date"="date")
  ) %>%
  rename(
    positivity_rate_5day_mb=positivity_rate,
    positivity_rate_5day_ywg=winnipeg
  )

write_feather(dashboard_5day_positivity_raw, dir_data_processed("dashboard_5day_positivity.feather"))
write_csv(dashboard_5day_positivity_raw, dir_data_processed("dashboard_5day_positivity.csv"))


################################################################################
# Daily snapshot of RHA-level daily cases, active, recovered, death.
################################################################################
dashboard_daily_status_interlake_eastern_raw <- jsonlite::fromJSON(dir_data_raw('dashboard_daily_status_interlake_eastern.json'))
dashboard_daily_status_interlake_eastern_raw <- dashboard_daily_status_interlake_eastern_raw[["features"]][["attributes"]]

dashboard_daily_status_northern_raw <- jsonlite::fromJSON(dir_data_raw('dashboard_daily_status_northern.json'))
dashboard_daily_status_northern_raw <- dashboard_daily_status_northern_raw[["features"]][["attributes"]]

dashboard_daily_status_prairie_mountain_health_raw <- jsonlite::fromJSON(dir_data_raw('dashboard_daily_status_prairie_mountain_health.json'))
dashboard_daily_status_prairie_mountain_health_raw <- dashboard_daily_status_prairie_mountain_health_raw[["features"]][["attributes"]]

dashboard_daily_status_southern_health_raw <- jsonlite::fromJSON(dir_data_raw('dashboard_daily_status_southern_health.json'))
dashboard_daily_status_southern_health_raw <- dashboard_daily_status_southern_health_raw[["features"]][["attributes"]]

dashboard_daily_status_winnipeg_raw <- jsonlite::fromJSON(dir_data_raw('dashboard_daily_status_winnipeg.json'))
dashboard_daily_status_winnipeg_raw <- dashboard_daily_status_winnipeg_raw[["features"]][["attributes"]]

dashboard_daily_status_manitoba <- rbind(
  dashboard_daily_status_interlake_eastern_raw,
  dashboard_daily_status_northern_raw,
  dashboard_daily_status_prairie_mountain_health_raw,
  dashboard_daily_status_southern_health_raw,
  dashboard_daily_status_winnipeg_raw
) %>%
clean_names() %>%
mutate(
  date=as.Date(as.POSIXct(as.integer(as.numeric(as.character(date)) / 1000.0), origin='1970-01-01', tz="GMT")),
  daily_cases=as.numeric(as.character(daily_cases)),
  cumulative_cases=as.numeric(as.character(cumulative_cases)),
  active_cases=as.numeric(as.character(active_cases)),
  recoveries=as.numeric(as.character(recoveries)),
  deaths=as.numeric(as.character(deaths)),
  rha=gsub("Prairie Mountain Health", "Prairie Mountain", rha, fixed=TRUE),
  rha=gsub("Southern Health-Santé Sud", "Southern", rha, fixed=TRUE),
  rha=factor(rha, levels=c(
        "Interlake-Eastern",
        "Northern",
        "Prairie Mountain",
        "Southern",
        "Winnipeg"
      ))
  ) %>%
  select(
    -object_id
  ) %>%
  left_join(
    manitoba_health_regions_populations,
    by=c("rha"="rha")
  ) %>%
  mutate(

    daily_cases_7day=roll_mean(daily_cases, 7, na.rm=TRUE, fill=NA, align="right"),
    active_cases_7day=roll_mean(active_cases, 7, na.rm=TRUE, fill=NA, align="right"),
    recoveries_7day=roll_mean(recoveries, 7, na.rm=TRUE, fill=NA, align="right"),
    deaths_7day=roll_mean(deaths, 7, na.rm=TRUE, fill=NA, align="right"),

    daily_cases_7day_100K=daily_cases_7day / pop_2019 * 100000,
    cumulative_cases_100K=cumulative_cases / pop_2019 * 100000,
    active_cases_7day_100K=active_cases_7day / pop_2019 * 100000,
    recoveries_7day_100K=recoveries_7day / pop_2019 * 100000,
    deaths_7day_100K=deaths_7day / pop_2019 * 100000

  ) %>%
  mutate(
    rha=factor(rha, levels=c(
        "Interlake-Eastern",
        "Northern",
        "Prairie Mountain",
        "Southern",
        "Winnipeg"
      )
    )
  )

write_feather(dashboard_daily_status_manitoba, dir_data_processed("dashboard_daily_status_manitoba.feather"))
write_csv(dashboard_daily_status_manitoba, dir_data_processed("dashboard_daily_status_manitoba.csv"))


################################################################################
# Daily snapshot of health district-level daily cases, active, recovered, death.
################################################################################
dashboard_daily_status_districts_all_raw <- jsonlite::fromJSON(dir_data_raw('dashboard_daily_status_districts_all.json'))
dashboard_daily_status_districts_all_raw <- dashboard_daily_status_districts_all_raw[["features"]][["attributes"]]
dashboard_daily_status_districts_all_raw <- dashboard_daily_status_districts_all_raw %>%
  clean_names() %>%
  mutate(
    date=as.Date(as.POSIXct(as.integer(as.numeric(as.character(date)) / 1000.0), origin='1970-01-01', tz="GMT"))
  ) %>%
  filter(
    rha != area_name
  ) %>%
  left_join(
    manitoba_health_districts_populations,
    by=c("area_name"="district", "rha"="rha")
  ) %>%
  mutate(
    district_total_cases_100K=total_cases / pop_2019 * 100000,
    district_active_cases_100K=active_cases / pop_2019 * 100000
  ) %>%
  filter(
    area_name %notin% c("Interlake-Eastern", "Northern", "Prairie Mountain Health",
                        "Southern Health-Santé Sud",
                        "Southern Health-Santé Sud", "Winnipeg")
  )

write_feather(dashboard_daily_status_districts_all_raw, dir_data_processed("dashboard_daily_status_districts_all.feather"))
write_csv(dashboard_daily_status_districts_all_raw, dir_data_processed("dashboard_daily_status_districts_all.csv"))




dashboard_daily_status_all_raw <- jsonlite::fromJSON(dir_data_raw('dashboard_daily_status_all.json'))
dashboard_daily_status_all_raw <- dashboard_daily_status_all_raw[["features"]][["attributes"]]
dashboard_daily_status_all_raw <- dashboard_daily_status_all_raw %>%
  clean_names() %>%
  mutate(
    date=as.Date(as.POSIXct(as.integer(as.numeric(as.character(date)) / 1000.0), origin='1970-01-01', tz="GMT")),
    epi_week=isoweek(date)
  )

write_feather(dashboard_daily_status_all_raw, dir_data_processed("dashboard_daily_status_all.feather"))
write_csv(dashboard_daily_status_all_raw, dir_data_processed("dashboard_daily_status_all.csv"))
