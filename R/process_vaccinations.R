
# Doses received (combined manufacturers)
COVID19_MB_vaccine_doses_received_raw <- jsonlite::fromJSON(dir_data_raw("mb_covid_vaccine_doses_distributed.json"))
COVID19_MB_vaccine_doses_received_raw <- COVID19_MB_vaccine_doses_received_raw[["features"]][["attributes"]]
COVID19_MB_vaccine_doses_received_raw <- COVID19_MB_vaccine_doses_received_raw %>%
  clean_names()

total_doses_distributed_val=COVID19_MB_vaccine_doses_received_raw %>% head(1) %>% select(doses_received) %>%  pull()

# Vaccination summary
COVID19_MB_vaccination_summary_raw <- jsonlite::fromJSON(dir_data_raw("mb_covid_vaccinations_summary_stats_updated.json"))
COVID19_MB_vaccination_summary_raw <- COVID19_MB_vaccination_summary_raw[["features"]][["attributes"]]
COVID19_MB_vaccination_summary_raw <- COVID19_MB_vaccination_summary_raw %>%
  clean_names() %>%
  mutate(
    total_doses_distributed=total_doses_distributed_val
  ) %>%
  mutate(
    date=as.Date(as.POSIXct(as.integer(as.numeric(as.character(date)) / 1000.0), origin="1970-01-01", tz="GMT"))
  )

write_feather(COVID19_MB_vaccination_summary_raw, dir_data_processed("COVID19_MB_vaccination_summary.feather"))


# MB Vaccine dashboard first and second vaccine doses
COVID19_MB_first_second_vaccine_dose_raw <- jsonlite::fromJSON(dir_data_raw("COVID19_MB_first_second_vaccine_dose.json"))
COVID19_MB_first_second_vaccine_dose_raw <- COVID19_MB_first_second_vaccine_dose_raw[["features"]][["attributes"]]
COVID19_MB_first_second_vaccine_dose_raw <- COVID19_MB_first_second_vaccine_dose_raw %>%
  select(
    -ObjectId
  ) %>%
  clean_names() %>%
  mutate(
    vaccination_date=as.Date(as.POSIXct(as.integer(as.numeric(as.character(vaccination_date)) / 1000.0), origin="1970-01-01", tz="GMT"))
  )

write_feather(COVID19_MB_first_second_vaccine_dose_raw, dir_data_processed("COVID19_MB_first_second_vaccine_dose.feather"))


# MB Vaccine dashboard vaccine demographics -- daily snapshot
COVID19_MB_vaccine_demographics_raw <- jsonlite::fromJSON(dir_data_raw("COVID19_MB_vaccine_demographics.json"))
COVID19_MB_vaccine_demographics_raw <- COVID19_MB_vaccine_demographics_raw[["features"]][["attributes"]]
COVID19_MB_vaccine_demographics_raw <- COVID19_MB_vaccine_demographics_raw %>%
  select(
    -ObjectId
  ) %>%
  clean_names()

write_feather(COVID19_MB_vaccine_demographics_raw, dir_data_processed("COVID19_MB_vaccine_demographics_raw.feather"))


# Vaccination distribution and administration through PHAC
vaccine_distribution <- read_csv(dir_data_raw("COVID19_vaccine_distribution.csv")) %>%
  clean_names() %>%
  mutate(
    date=as.Date(date_vaccine_distributed, "%d-%m-%Y")
  ) %>%
  arrange(date)

vaccine_administration <- read_csv(dir_data_raw("COVID19_vaccine_administration.csv")) %>%
  clean_names() %>%
  mutate(
    date=as.Date(date_vaccine_administered, "%d-%m-%Y")
  ) %>%
  arrange(date)

covid_vaccine <- left_join(
    vaccine_distribution,
    vaccine_administration,
    by=c("date"="date", "province"="province")
  ) %>%
  mutate(
    date=as.Date(date, "%Y-%m-%d")
  )

# # Pad a day for 'today' with MB numbers, other provinces are the day before
# covid_vaccine_last <- covid_vaccine %>% filter(date == max(date)) %>%
#   mutate(
#     date=as.Date(date, "%Y-%b-%d") + 1
#   )
#
# covid_vaccine <- rbind(covid_vaccine, covid_vaccine_last)



covid_vaccine <- covid_vaccine %>%
  mutate(
    vaccination_gap=format(cumulative_avaccine / cumulative_dvaccine * 100, digits=2),
    vaccination_gap=as.numeric(vaccination_gap),

    dose_difference=cumulative_dvaccine - cumulative_avaccine,
    cumulative_dose_difference=as.numeric(dose_difference)
  )




write_feather(covid_vaccine, dir_data_processed("covid_vaccine.feather"))
write_feather(vaccine_distribution, dir_data_processed("vaccine_distribution.feather"))


FN_vaccinations <- read_csv(dir_data_raw("FN_vaccinations.csv")) %>%
  clean_names() %>%
  rename(
    first_dose_fn=first_dose
  )

write_feather(FN_vaccinations, dir_data_processed("FN_vaccinations.feather"))
