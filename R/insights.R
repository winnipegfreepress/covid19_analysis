###########################################################
# Key insights
############################################################

############################################################
# Topline numbers
############################################################
today_topline <- dashboard_daily_status_districts_all %>%
  filter(rha=="All" & area=="All") %>%
  mutate(
    total_tests=as.numeric(as.character(total_tests)),
    daily_tests=as.numeric(as.character(daily_tests)),
    total_cases=as.numeric(as.character(total_cases)),
    active_cases =as.numeric(as.character(active_cases)),
    recovered=as.numeric(as.character(recovered)),
    deaths =as.numeric(as.character(deaths)),
    new_cases=as.numeric(as.character(new_cases)),
    current_hospitalizations =as.numeric(as.character(current_hospitalizations)),
    current_icu_patients =as.numeric(as.character(current_icu_patients)),
    population =as.numeric(as.character(population)),
  )

today_topline__date   <- today_topline$date
today_topline__last_update   <- today_topline$last_update
today_topline__rha   <- today_topline$rha
today_topline__area   <- today_topline$area
today_topline__area_name   <- today_topline$area_name
today_topline__total_tests   <- today_topline$total_tests
today_topline__daily_tests   <- today_topline$daily_tests
today_topline__total_cases   <- today_topline$total_cases
today_topline__active_cases   <- today_topline$active_cases
today_topline__recovered   <- today_topline$recovered
today_topline__deaths   <- today_topline$deaths
today_topline__new_cases   <- today_topline$new_cases
today_topline__current_hospitalizations   <- today_topline$current_hospitalizations
today_topline__current_icu_patients   <- today_topline$current_icu_patients

topline_message <-  paste(
  today_topline__new_cases, " cases today", "\n\n",
  "• ", comma(today_topline__active_cases), " active cases", "\n",
  "• ", comma(today_topline__current_hospitalizations), " individuals are hospitalized incl. ", comma(today_topline__current_icu_patients), " in ICU", "\n",
  "• ", comma(today_topline__deaths), " COVID-19 deaths", "\n",
  "• ", comma(today_topline__recovered), " cases have recovered", "\n",
  "• ", comma(today_topline__total_cases), " are confirmed or probable positive", "\n",
  "• ", comma(today_topline__total_tests), " COVID-19 tests completed to date", "\n",
  "\n", "#wfp", "\n",
  "\n", "==========", "\n\n",
  sep=""
)


############################################################
# New cases by health region
############################################################
today_regions <- dashboard_daily_status_manitoba %>%
  filter(date == max(date)) %>%
  select(date, rha,daily_cases)

today_regions__interlake_eastern  <- today_regions %>% filter(rha == "Interlake-Eastern") %>% pull(daily_cases)
today_regions__northern  <- today_regions %>% filter(rha == "Northern") %>% pull(daily_cases)
today_regions__prairie_mountain  <- today_regions %>% filter(rha == "Prairie Mountain") %>% pull(daily_cases)
today_regions__southern  <- today_regions %>% filter(rha == "Southern") %>% pull(daily_cases)
today_regions__winnipeg  <- today_regions %>% filter(rha == "Winnipeg") %>% pull(daily_cases)

rha_total=sum(today_regions$daily_cases)

today_date=today_regions$date %>% head(1)
today_date <- format(today_date, "%B %d")

today_reporting_diff=""
if(rha_total != today_topline__new_cases){
  today_reporting_diff=paste(
    rha_total, " of today's ", today_topline__new_cases, "cases are dated ", today_date
  )
}

today_regions_message <- paste(
  today_reporting_diff, "\n\n",
  "Interlake-Eastern: ", today_regions__interlake_eastern, "\n",
  "Northern: ", today_regions__northern, "\n",
  "Prairie Mountain: ", today_regions__prairie_mountain, "\n",
  "Southern: ", today_regions__southern, "\n",
  "Winnipeg: ", today_regions__winnipeg, "\n",
  "\n", "#wfp", "\n",
  "\n", "==========", "\n\n",
  sep=""
)


###########################################################
# Cases by district
###########################################################
today_districts <- dashboard_daily_status_districts_all %>%
  filter(date == max(date)) %>%
  select(date, rha, area_name, active_cases) %>%
  arrange(desc(active_cases)) %>%
  head(5)

today_districts_message <- paste(
  "Top 5 health districts for active cases of COVID-19", "\n\n",
  today_districts[["area_name"]][1], ": ", today_districts[["active_cases"]][1], "\n",
  today_districts[["area_name"]][2], ": ", today_districts[["active_cases"]][2], "\n",
  today_districts[["area_name"]][3], ": ", today_districts[["active_cases"]][3], "\n",
  today_districts[["area_name"]][4], ": ", today_districts[["active_cases"]][4], "\n",
  today_districts[["area_name"]][5], ": ", today_districts[["active_cases"]][5], "\n",
  "\n",
  "Due to a backlog in provincial tracking of recovered cases, active cases may be lower than reported.",
  "\n", "#wfp", "\n",
  "\n", "==========", "\n\n",
  sep=""
)


# ############################################################
# Today's new cases by reported age group
# Diff yesterday's demographics by RHA file from today's
# ############################################################
# dashboard_demographics_manitoba_daily_comp_2 <- left_join(
#   dashboard_demographics_manitoba_daily_tmp,
#   dashboard_demographics_manitoba,
#   by=c("rha"="rha", "age_group"="age_group", "gender"="gender")
# ) %>%
#   rename(value_today=value) %>%
#   mutate(new_cases=value_today - value_yesterday) %>%
#   filter(rha != "All")
#
# write_csv(dashboard_demographics_manitoba_daily_comp, here::here(dir_data_out, 'dashboard_demographics_manitoba_daily_comp.csv'))
#
# # dashboard_demographics_manitoba_daily_comp_2
# covid_ages_new_cases <- dashboard_demographics_manitoba_daily_comp_2 %>%
#   group_by(age_group) %>%
#   summarise(count=sum(new_cases))
#
# today_ages_message <- paste(
#   "Today's cases by age group.", "\n\n",
#
#   covid_ages_new_cases[["age_group"]][1], ": ", covid_ages_new_cases[["count"]][1], "\n",
#   covid_ages_new_cases[["age_group"]][2], ": ", covid_ages_new_cases[["count"]][2], "\n",
#   covid_ages_new_cases[["age_group"]][3], ": ", covid_ages_new_cases[["count"]][3], "\n",
#   covid_ages_new_cases[["age_group"]][4], ": ", covid_ages_new_cases[["count"]][4], "\n",
#   covid_ages_new_cases[["age_group"]][5], ": ", covid_ages_new_cases[["count"]][5], "\n",
#   covid_ages_new_cases[["age_group"]][6], ": ", covid_ages_new_cases[["count"]][6], "\n",
#   covid_ages_new_cases[["age_group"]][7], ": ", covid_ages_new_cases[["count"]][7], "\n",
#   covid_ages_new_cases[["age_group"]][8], ": ", covid_ages_new_cases[["count"]][8], "\n",
#   covid_ages_new_cases[["age_group"]][9], ": ", covid_ages_new_cases[["count"]][9], "\n",
#   covid_ages_new_cases[["age_group"]][10], ": ", covid_ages_new_cases[["count"]][10], "\n",
#   covid_ages_new_cases[["age_group"]][11], ": ", covid_ages_new_cases[["count"]][11], "\n",
#
#   "\n", "#wfp", "\n",
#   "\n", "==========", "\n\n",
#   sep=""
# )


############################################################
# Print compiled insights to screen
############################################################
# wfp_mb_health_region_active.png
cat(topline_message)
cat(today_regions_message)
cat(today_districts_message)
# cat(today_ages_message)
