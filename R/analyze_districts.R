

COVID19_MB_districts <- read_feather(dir_data_processed("COVID19_district_details.feather")) %>%
  #
  # districts_northern_daily_new <- districts_df %>%
  #   filter(rha == "Northern") %>%
    filter(area_name != rha) %>%
    arrange(date) %>%
    group_by(area_name) %>%
    mutate(
      new_daily_cases = value - lag(value),
      new_14day_cases = value - lag(value, 14),
      new_14day_cases_pct_chg = (value - lag(value, 14)) / lag(value, 14) * 100,
      area_name_fac = factor(area_name)
    ) %>%
  ungroup()

