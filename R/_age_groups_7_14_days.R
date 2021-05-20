
dashboard_demographics <- read_csv(dir_data_out("demographics_df.csv"))



MB_pop_estimates_2020 <- MB_pop_estimates_2020_statcan_17_10_0005_01 %>%
  group_by(age_group_mb) %>%
  summarize(total = sum(population_2020est)) %>%
  mutate(
    age_group_mb = ifelse(age_group_mb == "100+", "99+", age_group_mb)
  )

dashboard_demographics_allrha <- read_csv(dir_data_out("demographics_df.csv")) %>%
  filter(rha == "All") %>%
  select(-rha) %>%
  pivot_wider(names_from = gender, values_from = value) %>%
  clean_names() %>%
  mutate(
    total_cases = male + female
  ) %>%
  left_join(
    MB_pop_estimates_2020,
    by = c("age_group" = "age_group_mb")
  ) %>%
  rename(
    population_2020est = total
  ) %>%
  mutate(
    cumulative_case_rate = total_cases / population_2020est * 100000
  )


dashboard_demographics_allrha_today <- dashboard_demographics_allrha %>%
  filter(date == max(date)) %>%
  rename(
    total_cases_may06 = total_cases
  ) %>%
  select(
    age_group, total_cases_may06
  )


dashboard_demographics_allrha_7days <- dashboard_demographics_allrha %>%
  filter(date == max(date) - 6) %>%
  rename(
    total_7daysago = total_cases
  ) %>%
  select(
    age_group, total_7daysago
  )


dashboard_demographics_allrha_14days <- dashboard_demographics_allrha %>%
  filter(date == max(date) - 13) %>%
  rename(
    total_cases_14daysago = total_cases
  ) %>%
  select(
    age_group, total_cases_14daysago
  )


dashboard_demographics_7_14 <- left_join(
  dashboard_demographics_allrha_today,
  dashboard_demographics_allrha_7days,
  by=c("age_group" = "age_group")
) %>%
  left_join(
    dashboard_demographics_allrha_14days,
    by=c("age_group" = "age_group")
  ) %>%
  mutate(
    new_7days = total_cases_may06 - total_7daysago,
    new_14days = total_cases_may06 - total_cases_14daysago
  ) %>%
  select(
    age_group,
    new_7days,
    new_14days,
    total_cases_may06,
    total_7daysago,
    total_cases_14daysago
  )
