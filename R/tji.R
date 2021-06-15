################################################################################
# Manually enter some of the values from the news bulletin
# then run to grab other values and generate TJI/webbie.
# TODO: add some logic for days when Winnipeg positivity isn't provided, etc.
################################################################################

# TJI fields in a gsheet
GET("https://docs.google.com/spreadsheets/d/e/2PACX-1vSnFrVop0T3Jz7G1ZWRm-5EiONBWe91icwVgrMOA1mfpN47-Xqri83fIvx1ScBFDtt3De66x_YmiAMg/pub?gid=362680117&single=true&output=csv",
    write_disk(dir_data_raw('wfp_tji.csv'), overwrite=TRUE))

gsheet_wfp_tji <- read_csv(dir_data_raw("wfp_tji.csv")) %>%
  clean_names()

# topline numbers from dashboard for TJI
GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_cases_summary_stats_geography/FeatureServer/0/query?f=json&where=RHA%3D%27All%27&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outSR=102100&resultOffset=0&resultRecordCount=1&resultType=standard&cacheHint=true",
      write_disk(dir_data_raw('dashboard_daily_topline.json'), overwrite=TRUE))

dashboard_daily_topline_raw <- jsonlite::fromJSON(dir_data_raw('dashboard_daily_topline.json'))
dashboard_daily_topline_raw <- dashboard_daily_topline_raw[["features"]][["attributes"]]
dashboard_daily_topline_raw <- dashboard_daily_topline_raw %>%
  clean_names() %>%
  mutate(
    date=as.Date(as.POSIXct(as.integer(as.numeric(as.character(date)) / 1000.0), origin='1970-01-01', tz="GMT"))
  ) %>%
  select(
    -object_id
  )

# Pull daily bulletin details from a Google Sheet that has been updated.
tji_daily_deaths <- gsheet_wfp_tji %>% filter(field == "daily_deaths") %>% select(value) %>% pull()
tji_positivity_manitoba <- gsheet_wfp_tji %>% filter(field == "positivity_manitoba") %>% select(value) %>% pull()
tji_positivity_winnipeg <- gsheet_wfp_tji %>% filter(field == "positivity_winnipeg") %>% select(value) %>% pull()
tji_rha_interlake <- gsheet_wfp_tji %>% filter(field == "rha_interlake") %>% select(value) %>% pull()
tji_rha_northern <- gsheet_wfp_tji %>% filter(field == "rha_northern") %>% select(value) %>% pull()
tji_rha_prairiemountain <- gsheet_wfp_tji %>% filter(field == "rha_prairiemountain") %>% select(value) %>% pull()
tji_rha_southern <- gsheet_wfp_tji %>% filter(field == "rha_southern") %>% select(value) %>% pull()
tji_rha_winnipeg <- gsheet_wfp_tji %>% filter(field == "rha_winnipeg") %>% select(value) %>% pull()
tji_hospitalized_total <- gsheet_wfp_tji %>% filter(field == "hospitalized_total") %>% select(value) %>% pull()
tji_icu_total  <- gsheet_wfp_tji %>% filter(field == "icu_total") %>% select(value) %>% pull()


tji_voc_new_b1117 <-   gsheet_wfp_tji %>% filter(field == "voc_new_b1117") %>% select(value) %>% pull()
tji_voc_new_b1351 <-   gsheet_wfp_tji %>% filter(field == "voc_new_b1351") %>% select(value) %>% pull()
tji_voc_new_p1 <-  gsheet_wfp_tji %>% filter(field == "voc_new_p1") %>% select(value) %>% pull()
tji_voc_new_b1617 <-  gsheet_wfp_tji %>% filter(field == "voc_new_b1617") %>% select(value) %>% pull()
tji_voc_new_uncat <- gsheet_wfp_tji %>% filter(field == "voc_new_unknown") %>% select(value) %>% pull()

tji_voc_total_b1117 <-   gsheet_wfp_tji %>% filter(field == "voc_total_b1117") %>% select(value) %>% pull()
tji_voc_total_b1351 <-   gsheet_wfp_tji %>% filter(field == "voc_total_b1351") %>% select(value) %>% pull()
tji_voc_total_p1 <-  gsheet_wfp_tji %>% filter(field == "voc_total_p1") %>% select(value) %>% pull()
tji_voc_total_b1617 <-  gsheet_wfp_tji %>% filter(field == "voc_total_b1617") %>% select(value) %>% pull()
tji_voc_total_uncat <- gsheet_wfp_tji %>% filter(field == "voc_total_unknown") %>% select(value) %>% pull()

# Cast to numeric
tji_voc_new_b1117 <-  as.numeric(as.character(tji_voc_new_b1117))
tji_voc_new_b1351 <-  as.numeric(as.character(tji_voc_new_b1351))
tji_voc_new_p1 <-  as.numeric(as.character(tji_voc_new_p1))
tji_voc_new_b1617 <-  as.numeric(as.character(tji_voc_new_b1617))
tji_voc_new_uncat <- as.numeric(as.character(tji_voc_new_uncat))

tji_voc_total_b1117 <-  as.numeric(as.character(tji_voc_total_b1117))
tji_voc_total_b1351 <-  as.numeric(as.character(tji_voc_total_b1351))
tji_voc_total_p1 <-  as.numeric(as.character(tji_voc_total_p1))
tji_voc_total_b1617 <-  as.numeric(as.character(tji_voc_total_b1617))
tji_voc_total_uncat <- as.numeric(as.character(tji_voc_total_uncat))

total_new_voc <- tji_voc_new_b1117 + tji_voc_new_b1351 + tji_voc_new_p1 + tji_voc_new_b1617 + tji_voc_new_uncat
total_voc <- tji_voc_total_b1117 + tji_voc_total_b1351 + tji_voc_total_p1 + tji_voc_total_b1617 + tji_voc_total_uncat


################################################################################
# Deal with variant cases
################################################################################
new_b117_str <- ""
new_b1351_str <- ""
new_p1_str <- ""
new_uncat_str <- ""

# if(tji_voc_new_b1117 > 0){
#   if(tji_voc_new_b1117 == 1){
#     new_b117_str <- "• one case of the B.1.1.7 variant"
#   }
#   if(tji_voc_new_b1117 > 1){
#     new_b117_str <- paste("• ", tji_voc_new_b1117, " cases of the B.1.1.7 variant", sep="")
#   }
# }
#
# if(tji_voc_new_b1351 > 0){
#   if(tji_voc_new_b1351 == 1){
#     new_b1351_str <- "• one case of the B.1.351 variant"
#   }
#   if(tji_voc_new_b1351 > 1){
#     new_b1351_str <- paste("• ", tji_voc_new_b1351, " cases of the B.1.351 variant", sep="")
#   }
# }
#
# if(tji_voc_new_p1 > 0){
#
#   if(tji_voc_new_p1 == 1){
#     new_p1_str <- "• one case of the P.1 variant"
#   }
#   if(tji_voc_new_p1 > 1){
#     new_p1_str <- paste("• ", tji_voc_new_p1, " cases of the P.1 variant", sep="")
#   }
# }
#
# if (tji_voc_new_uncat > 0) {
#   if (tji_voc_new_uncat == 1) {
#     new_uncat_str <- "• one uncategorized variant of concern case"
#   }
#   if (tji_voc_new_uncat > 1) {
#     new_uncat_str <- paste("• ", tji_voc_new_uncat, " uncategorized variant of concern cases", sep = "")
#   }
# }
#
#
# tji_new_voc_hed_str <-  ""
# new_voc_str=""
#
# if(total_new_voc > 0){
#
#   new_voc_str <- paste("Laboratory testing of previously reported cases has identified: ",
#                          "\n", new_b117_str,
#                          "\n", new_b1351_str,
#                          "\n", new_p1_str,
#                          "\n", new_uncat_str,
#                         sep=""
#                        )
#
#   tji_new_voc_hed_str <- paste(total_new_voc, " variant of concern cases and ", sep="")
#
# }
#
#
total_b1117_str <- paste("zero cases of B.1.1.7")
total_b1351_str <- paste("zero cases of B.1.351")
oc_total_p1_str <- paste("zero cases of P.1")



if(tji_voc_total_b1117 > 1){
  total_b1117_str <- paste(comma(tji_voc_total_b1117), " cases of B.1.1.7", sep="")
}
if(tji_voc_total_b1351 > 1){
  total_b1351_str <- paste(comma(tji_voc_total_b1351), " cases of B.1.351", sep="")
}
if(tji_voc_total_p1 > 1){
  oc_total_p1_str <- paste(comma(tji_voc_total_p1), " cases of the P.1 variant", sep="")
}
if(tji_voc_total_b1617 > 1){
  oc_total_b1617_str <- paste(comma(tji_voc_total_b1617), " cases of the B.1.617 variant lineage", sep="")
}
oc_total_uncat_str <- ""
if (tji_voc_total_uncat > 1) {
  oc_total_uncat_str <- paste(comma(tji_voc_total_uncat), " uncategorized variant of concern cases", sep = "")
}



total_voc_str <- paste(
  "Public health officials have reported a total of ", "\n",
  comma(total_voc), " variant of concern cases in Manitoba including ", "\n",
  total_b1117_str, ", ", "\n",
  total_b1351_str, " and ", "\n",
  oc_total_p1_str, ".", "\n",
  oc_total_uncat_str, ".", "\n",
  sep=""
)

total_voc_str <- ""
################################################################################
# Deaths
################################################################################
deaths_details <- gsheet_wfp_tji %>% filter(field %in% c("death_bullet", "covid_death"))
deaths_details_str <- ""

# separate COVID-19 deaths with a newline
if(nrow(deaths_details) > 0){

  if(nrow(deaths_details) == 1){
    deaths_details_str <-  paste("The new death is:", sep="")
  }

  if(nrow(deaths_details) > 1){
    deaths_details_str <-  paste("The new deaths include: ", sep="")
  }

  for (row in 1:nrow(deaths_details)) {
    bullet_str <- deaths_details[row, "value"]
    deaths_details_str <- paste(deaths_details_str, "\n", bullet_str, sep="")
  }
}


# Clean up the death bullets
deaths_details_str <- gsub("female", "woman", deaths_details_str, fixed=TRUE)
deaths_details_str <- gsub("male", "man", deaths_details_str, fixed=TRUE)

deaths_details_str <- gsub("; and", "", deaths_details_str, fixed=TRUE)
deaths_details_str <- gsub(";", "", deaths_details_str, fixed=TRUE)


# Topline numbers from the dashboard
date_str <- dashboard_daily_topline_raw %>% select(date) %>% pull()
last_update_str <- dashboard_daily_topline_raw %>% select(last_update) %>% pull()
rha_str <- dashboard_daily_topline_raw %>% select(rha) %>% pull()
area_str <- dashboard_daily_topline_raw %>% select(area) %>% pull()
area_name_str <- dashboard_daily_topline_raw %>% select(area_name) %>% pull()
total_tests_str <- dashboard_daily_topline_raw %>% select(total_tests) %>% pull()
daily_tests_str <- dashboard_daily_topline_raw %>% select(daily_tests) %>% pull()
total_cases_str <- dashboard_daily_topline_raw %>% select(total_cases) %>% pull()
active_cases_str <- dashboard_daily_topline_raw %>% select(active_cases) %>% pull()
recovered_str <- dashboard_daily_topline_raw %>% select(recovered) %>% pull()
deaths_str <- dashboard_daily_topline_raw %>% select(deaths) %>% pull()
new_cases_str <- dashboard_daily_topline_raw %>% select(new_cases) %>% pull()
current_hospitalizations_str <- dashboard_daily_topline_raw %>% select(current_hospitalizations) %>% pull()
current_icu_patients_str <- dashboard_daily_topline_raw %>% select(current_icu_patients) %>% pull()
population_str <- dashboard_daily_topline_raw %>% select(population) %>% pull()
rate_str <- dashboard_daily_topline_raw %>% select(rate) %>% pull()

# today
today_date <- Sys.Date()
today_name <- wday(today_date, label=TRUE, abbr=FALSE)


# Singular/plural strings for deaths in hed and body
if(tji_daily_deaths == 1){
  tji_daily_deaths_str <- paste("one more death", sep="")
  tji_daily_deaths_hed_str <- paste("one death", sep="")
}

if(tji_daily_deaths > 1){
  tji_daily_deaths_str <- paste(tji_daily_deaths, " more deaths", sep="")
  tji_daily_deaths_hed_str <- paste(tji_daily_deaths, " deaths", sep="")
}

if(tji_daily_deaths == 0){
  tji_daily_deaths_str <- paste("no new deaths", sep="")
  tji_daily_deaths_hed_str <- paste("no new deaths", sep="")
}



# headline <-  paste("", new_cases_str, " new COVID-19 cases, ", tji_new_voc_hed_str, " ", tji_daily_deaths_hed_str, " in Manitoba ", today_name, sep="")
headline <-  paste("", new_cases_str, " new COVID-19 cases and ",  tji_daily_deaths_hed_str, " in Manitoba ", today_name, sep="")

story <- paste(
  "Provincial health officials announced ",  new_cases_str, " new cases of COVID-19 and ",  tji_daily_deaths_str, " in Manitoba ", today_name, ".",
  "\n","\n",
  "There are ",  comma(active_cases_str), " active cases in Manitoba, with ",  tji_hospitalized_total, " people in hospital, ",  tji_icu_total, " of them in intensive care.",
  "\n","\n",
  "The five-day test positivity rate is ",  tji_positivity_manitoba, " in Manitoba, and ",  tji_positivity_winnipeg, " in Winnipeg. ",
  "\n","\n",
  deaths_details_str,
  "\n", "\n",
  "Of the new cases announced ", today_name, ", ",  tji_rha_winnipeg, " are in the Winnipeg health region, ",  tji_rha_southern, " in Southern Health; ",  tji_rha_interlake, " in Interlake–Eastern; ",  tji_rha_prairiemountain, " in Prairie Mountain; and ",  tji_rha_northern, " in Northern Health.",
  sep=""
)


tji_hed_body <- paste(
  headline,
  "\n","\n",
  story,
  sep=""
)
