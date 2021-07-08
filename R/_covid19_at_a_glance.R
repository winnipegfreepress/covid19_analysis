c19_at_a_glance <- wfp_daily_totals %>%
  select(
    date,
    new_daily_cases,
    confirmed_and_probable,
    deaths,
    new_daily_deaths,
    total_hospital,
    total_icu,
    active_hospital,
    active_icu,
    test_daily_diff,
    new_daily_tests,
    cases_mavg_7day,
    tests_mavg_7day,
    hospital_total_mavg_7day,
    icu_total_mavg_7day,
    hospital_active_mavg_7day,
    icu_active_mavg_7day,
    deaths_mavg_7day,
    new_daily_cases_100K,
    new_7day_cases_100K
  )


