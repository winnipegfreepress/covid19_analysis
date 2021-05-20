
COVID19_MB_vaccine_doses_received_raw <- jsonlite::fromJSON(dir_data_raw("vaccine_dist/2021-04-05-mb_covid_vaccine_doses_distributed.json"))
COVID19_MB_vaccine_doses_received_raw <- COVID19_MB_vaccine_doses_received_raw[["features"]][["attributes"]]
COVID19_MB_vaccine_doses_received_raw <- COVID19_MB_vaccine_doses_received_raw %>%
  clean_names()

View(COVID19_MB_vaccine_doses_received_raw)
