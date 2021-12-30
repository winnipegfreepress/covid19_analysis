
################################################################################
# Manitoba Health vaccination dashboard
################################################################################

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_vaccinations_summary_stats/FeatureServer/0/query?f=json&where=RHA%3D%27All%27&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outSR=102100&resultOffset=0&resultRecordCount=50&resultType=standard&cacheHint=true",
    write_disk(dir_data_raw("mb_covid_vaccinations_summary_stats.json"), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_vaccinations_manufacturers/FeatureServer/0/query?f=json&where=Manufacturer%3D%27All%27&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&resultOffset=0&resultRecordCount=50&resultType=standard&cacheHint=true",
    write_disk(dir_data_raw("mb_covid_vaccine_doses_distributed.json"), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_vaccinations_daily_cumulative_02/FeatureServer/0/query?f=json&where=1=1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Vaccination_Date%20asc&outSR=102100&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true",
    write_disk(dir_data_raw("COVID19_MB_first_second_vaccine_dose.json"), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_vaccinations_demographics/FeatureServer/0/query?f=json&where=Age_Group%3C%3E%27All%27&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outSR=102100&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true",
    write_disk(dir_data_raw("COVID19_MB_vaccine_demographics.json"), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_vaccinations_summary_stats/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&resultOffset=0&resultRecordCount=1&resultType=standard&cacheHint=true",
    write_disk(dir_data_raw("mb_covid_vaccinations_summary_stats_updated.json"), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_vaccinations_18_coverage/FeatureServer/0/query?f=json&where=RHA%3D%27All%27&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&resultOffset=0&resultRecordCount=50&resultType=standard&cacheHint=true",
    write_disk(dir_data_raw("mb_covid_vaccinations_18plus_coverage.json"), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://services.arcgis.com/mMUesHYPkXjaFGfS/arcgis/rest/services/mb_covid_vaccinations_inventory_stats/FeatureServer/0/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&resultOffset=0&resultRecordCount=50&resultType=standard&cacheHint=true",
    write_disk(dir_data_raw("mb_covid_vaccinations_inventory_stats.json"), overwrite=TRUE))
Sys.sleep(time_pause)


GET("https://opendata.arcgis.com/api/v3/datasets/0be6f85a9c054b66acd88c9d8ed079fd_0/downloads/data?format=csv&spatialRefId=3857",
    write_disk(dir_data_raw("Manitoba_COVID-19_Vaccine_Uptake_by_District.csv"), overwrite=TRUE))
Sys.sleep(time_pause)



################################################################################
# COVID-19 CANADA OPEN DATA WORKING GROUP
################################################################################

GET("https://github.com/ishaberry/Covid19Canada/raw/master/timeseries_prov/vaccine_administration_timeseries_prov.csv",
    write_disk(dir_data_raw("COVID19_vaccine_administration.csv"), overwrite=TRUE))
Sys.sleep(time_pause)

GET("https://github.com/ishaberry/Covid19Canada/raw/master/timeseries_prov/vaccine_distribution_timeseries_prov.csv",
    write_disk(dir_data_raw("COVID19_vaccine_distribution.csv"), overwrite=TRUE))
Sys.sleep(time_pause)


