################################################################################
# Download and cache the source data for processing and analysis
################################################################################

# No need for auth to pull as read-only
gs4_deauth()


################################################################################
# Provincial health district populations
################################################################################
GET("https://docs.google.com/spreadsheets/d/e/2PACX-1vRxuvJ3N-uLh2Cxndtn491fw8T06u2u97_aAlR_QvNjNbBb3L_rT4nFN5D2zyhZ26uPij84Z974wx8Y/pub?output=csv",
    write_disk(dir_data_raw("wfp_manitoba_health_districts_populations.csv"), overwrite=TRUE))
Sys.sleep(time_pause)


################################################################################
# Winnipeg Free Press tracker - gsheet
################################################################################
GET("https://docs.google.com/spreadsheets/d/e/2PACX-1vSnFrVop0T3Jz7G1ZWRm-5EiONBWe91icwVgrMOA1mfpN47-Xqri83fIvx1ScBFDtt3De66x_YmiAMg/pub?gid=1935428018&single=true&output=csv",
    write_disk(dir_data_raw("gsheet_wfp_daily_totals.csv"), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://docs.google.com/spreadsheets/d/e/2PACX-1vSnFrVop0T3Jz7G1ZWRm-5EiONBWe91icwVgrMOA1mfpN47-Xqri83fIvx1ScBFDtt3De66x_YmiAMg/pub?gid=734049138&single=true&output=csv",
    write_disk(dir_data_raw("gsheet_wfp_annotations.csv"), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://docs.google.com/spreadsheets/d/e/2PACX-1vSnFrVop0T3Jz7G1ZWRm-5EiONBWe91icwVgrMOA1mfpN47-Xqri83fIvx1ScBFDtt3De66x_YmiAMg/pub?gid=322055627&single=true&output=csv",
    write_disk(dir_data_raw("gsheet_wfp_test_positivity.csv"), overwrite=TRUE))
Sys.sleep(time_pause)


# WFP tracker pulled from weekly COVID-19 epi reports
GET("https://docs.google.com/spreadsheets/d/e/2PACX-1vSnFrVop0T3Jz7G1ZWRm-5EiONBWe91icwVgrMOA1mfpN47-Xqri83fIvx1ScBFDtt3De66x_YmiAMg/pub?gid=1486577754&single=true&output=csv",
    write_disk(dir_data_raw("gsheet_wfp_healthcareworkers.csv"), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://docs.google.com/spreadsheets/d/e/2PACX-1vSnFrVop0T3Jz7G1ZWRm-5EiONBWe91icwVgrMOA1mfpN47-Xqri83fIvx1ScBFDtt3De66x_YmiAMg/pub?gid=481773466&single=true&output=csv",
    write_disk(dir_data_raw("gsheet_wfp_transmission_source.csv"), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://docs.google.com/spreadsheets/d/e/2PACX-1vSnFrVop0T3Jz7G1ZWRm-5EiONBWe91icwVgrMOA1mfpN47-Xqri83fIvx1ScBFDtt3De66x_YmiAMg/pub?gid=1996696270&single=true&output=csv",
    write_disk(dir_data_raw("gsheet_wfp_symptoms.csv"), overwrite=TRUE))
Sys.sleep(time_pause)


################################################################################
# Public Health Agency of Canada - daily counts
################################################################################
GET("https://health-infobase.canada.ca/src/data/covidLive/covid19.csv",
    write_disk(dir_data_raw("phac_daily.csv"), overwrite=TRUE))
Sys.sleep(time_pause)


################################################################################
# Manitoba Health COVID-19 dashboard
################################################################################
GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_5_day_positivity_rate/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Date%20asc&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true",
  write_disk(dir_data_raw("dashboard_5day_positivity.json"), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_cases_by_status_daily_rha/FeatureServer/0/query?f=json&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Date%20asc&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true&where=RHA%3D%27All%27",
  write_disk(dir_data_raw('dashboard_daily_status_all.json'), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_cases_by_status_daily_rha/FeatureServer/0/query?f=json&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Date%20asc&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true&where=RHA%3D%27Interlake-Eastern%27",
  write_disk(dir_data_raw('dashboard_daily_status_interlake_eastern.json'), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_cases_by_status_daily_rha/FeatureServer/0/query?f=json&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Date%20asc&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true&where=RHA%3D%27Northern%27",
  write_disk(dir_data_raw('dashboard_daily_status_northern.json'), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_cases_by_status_daily_rha/FeatureServer/0/query?f=json&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Date%20asc&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true&where=RHA%3D%27Prairie%20Mountain%20Health%27",
  write_disk(dir_data_raw('dashboard_daily_status_prairie_mountain_health.json'), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_cases_by_status_daily_rha/FeatureServer/0/query?f=json&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Date%20asc&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true&where=RHA%3D%27Southern%20Health-Sant%C3%A9%20Sud%27",
  write_disk(dir_data_raw('dashboard_daily_status_southern_health.json'), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_cases_by_status_daily_rha/FeatureServer/0/query?f=json&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Date%20asc&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true&where=RHA%3D%27Winnipeg%27",
  write_disk(dir_data_raw('dashboard_daily_status_winnipeg.json'), overwrite=TRUE))
Sys.sleep(time_pause)


################################################################################
# Health district-level
################################################################################
GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_cases_summary_stats_geography/FeatureServer/0/query?f=json&where=Total_Cases%3E0&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=RHA%20asc%2CArea_Name%20asc&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true",
    write_disk(dir_data_raw('dashboard_daily_status_districts_all.json'), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_cases_summary_stats_geography/FeatureServer/0/query?f=json&where=(Area%20NOT%20IN(%27Interlake-Eastern%27%2C%20%27Northern%27%2C%20%27Prairie%20Mountain%20Health%27%2C%20%27Southern%20Health-Sant%C3%A9%20Sud%27%2C%20%27Winnipeg%27)%20AND%20Total_Cases%3E0)%20AND%20(RHA%3D%27Winnipeg%27)&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=RHA%20asc%2CArea_Name%20asc&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true",
    write_disk(dir_data_raw('dashboard_daily_status_districts_winnipeg.json'), overwrite=TRUE))
Sys.sleep(time_pause)



################################################################################
# COVID-19 variants
################################################################################
GET("https://docs.google.com/spreadsheets/d/e/2PACX-1vSnFrVop0T3Jz7G1ZWRm-5EiONBWe91icwVgrMOA1mfpN47-Xqri83fIvx1ScBFDtt3De66x_YmiAMg/pub?gid=4072128&single=true&output=csv",
    write_disk(dir_data_raw('covid_variants.csv'), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://opendata.arcgis.com/datasets/55f0c39494c947a49a3ce32117edd532_0.geojson",
    write_disk(dir_data_raw('mbdata_variant_of_concern_cases.json'), overwrite=TRUE))
Sys.sleep(time_pause)


################################################################################
# Manitoba Health vaccination dashboard
################################################################################
source(dir_src("get_vaccinations.R"))



################################################################################
# Save a copy of the data as a snapshot zip
################################################################################
cache_time <- format(Sys.time(), "%Y-%m-%d--%H-%M")
cache_filename <- paste("data-raw-", cache_time, ".zip", sep="")

zip::zipr(
  here::here("data/cache", cache_filename),
	dir_data_raw()
)
