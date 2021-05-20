
# Update timestamp
last_update_timestamp=Sys.Date()

# Pull latest topline numbers for summaries, etc.
new_daily_cases_str <- wfp_daily_totals_last_date %>% select(new_daily_cases) %>% pull()
test_to_date_str <- wfp_daily_totals_last_date %>% select(test_to_date) %>% pull()
confirmed_and_probable_str <- wfp_daily_totals_last_date %>% select(confirmed_and_probable) %>% pull()
deaths_str <- wfp_daily_totals_last_date %>% select(deaths) %>% pull()
recovered_str <- wfp_daily_totals_last_date %>% select(recovered) %>% pull()
active_str <- wfp_daily_totals_last_date %>% select(active) %>% pull()
total_hospital_str <- wfp_daily_totals_last_date %>% select(total_hospital) %>% pull()
total_icu_str <- wfp_daily_totals_last_date %>% select(total_icu) %>% pull()

tweet_str <- paste(
  comma(new_daily_cases_str, accuracy=1), " cases of COVID-19 reported in Manitoba today",
  "\n", "• ", comma(test_to_date_str, accuracy=1), " tests completed",
  "\n", "• ", comma(confirmed_and_probable_str, accurac=1), " confirmed/probable positive cases",
  "\n", "• ", comma(deaths_str, accuracy=1), " COVID-19 deaths",
  "\n", "• ", comma(recovered_str, accuracy=1), " recovered cases",
  "\n", "• ", comma(active_str, accuracy=1), " active cases",
  "\n", "• ", comma(total_hospital_str, accuracy=1), " cases in hospital including ", comma(total_icu_str, accuracy=1), " in ICU",
  "\n\n", "#wfp",
  "\n\n",
  sep="")

cat(tweet_str)


