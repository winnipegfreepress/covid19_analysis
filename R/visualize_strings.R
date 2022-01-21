
wfp_daily_totals_last_date <- wfp_daily_totals %>%
  filter(date == max(date))

# Pull latest topline numbers for summaries, etc.
test_to_date_str <- wfp_daily_totals_last_date %>% select(test_to_date) %>% pull()
confirmed_and_probable_str <- wfp_daily_totals_last_date %>% select(confirmed_and_probable) %>% pull()
deaths_str <- wfp_daily_totals_last_date %>% select(deaths) %>% pull()
recovered_str <- wfp_daily_totals_last_date %>% select(recovered) %>% pull()
active_str <- wfp_daily_totals_last_date %>% select(active) %>% mutate(active=as.numeric(as.character(active))) %>% pull()
total_hospital_str <- wfp_daily_totals_last_date %>% select(total_hospital) %>% pull()
total_icu_str <- wfp_daily_totals_last_date %>% select(total_icu) %>% pull()

summary_str <- paste(
  "Of the",
  comma(test_to_date_str, accuracy=1), "tests completed, there are",
  comma(confirmed_and_probable_str, accuracy=1), "confirmed or probable positive cases of COVID-19 in Manitoba.",
  comma(deaths_str, accuracy=1), "deaths are attributed to COVID-19 and",
  comma(recovered_str, accuracy=1), "cases have recovered. There are",
  comma(active_str, accuracy=1), "active cases and",
  comma(total_hospital_str, accuracy=1), "cases in hospital including",
  comma(total_icu_str, accuracy=1), "in ICU.",
  sep=" ")

