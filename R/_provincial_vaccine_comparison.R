
GET("https://api.opencovid.ca/timeseries?stat=avaccine&loc=prov",
    write_disk(dir_data_raw("c19ca_vaccine_administererd.json"), overwrite=TRUE))
Sys.sleep(time_pause)


GET("https://api.opencovid.ca/timeseries?stat=cvaccine&loc=prov",
    write_disk(dir_data_raw("c19ca_vaccine_completed.json"), overwrite=TRUE))
Sys.sleep(time_pause)

c19ca_vaccine_administered <- jsonlite::fromJSON(dir_data_raw('c19ca_vaccine_administererd.json'))
c19ca_vaccine_administered <- c19ca_vaccine_administered[["avaccine"]]
c19ca_vaccine_administered <- c19ca_vaccine_administered %>%
  mutate(
    date = as.Date(date_vaccine_administered, format="%d-%m-%Y")
  )

c19ca_vaccine_completed <- jsonlite::fromJSON(dir_data_raw('c19ca_vaccine_completed.json'))
c19ca_vaccine_completed <- c19ca_vaccine_completed[["cvaccine"]]
c19ca_vaccine_completed <- c19ca_vaccine_completed %>%
  mutate(
    date = as.Date(date_vaccine_completed, format="%d-%m-%Y")
  )

provincial_population_12older_2020 <- read_csv(dir_data_raw("provincial_population_12older_total_2020_1710000501.csv")) %>%
  clean_names() %>%
  mutate(
    province_alt = ifelse(province == "British Columbia", "BC",
                    ifelse(province == "Newfoundland and Labrador", "NL",
                    ifelse(province == "Prince Edward Island", "PEI",
                    ifelse(province == "Northwest Territories", "NWT",
                      province
                    ))))
  )


# Join the vaccinations for the latest date
provincial_vaccinations <- left_join(
  c19ca_vaccine_administered %>% filter(date == max(date)),
  c19ca_vaccine_completed %>% filter(date == max(date)),
  by=c("province"="province")
) %>%
  rename(
    date = date.x
  ) %>%
  left_join(
    provincial_population_12older_2020,
    by=c("province"="province_alt")
  ) %>%
  select(
    -province
  ) %>%
  rename(
    province = province.y
  ) %>%
  mutate(
    cumulative_first_doses = cumulative_avaccine - cumulative_cvaccine,
    pct_one_dose = cumulative_first_doses / total_population_12_or_older * 100,
    pct_two_dose = cumulative_cvaccine / total_population_12_or_older * 100
  ) %>%
  select(
    date,
    province,
    total_population_12_or_older,
    avaccine,
    cvaccine,
    cumulative_avaccine,
    cumulative_cvaccine,
    cumulative_first_doses,
    pct_one_dose,
    pct_two_dose,
    date.y,
    date_vaccine_administered,
    date_vaccine_completed
  )

provincial_vaccinations_pct_tall <- provincial_vaccinations %>%
  select(
    province,
    pct_one_dose,
    pct_two_dose
  ) %>%
  pivot_longer(
    !province,
    names_to="type",
    values_to="pct"
  )

# Statistics Canada. Table 17-10-0005-01 Population estimates on July 1st, by age and sex
#
# p<-ggplot(provincial_vaccinations_pct_tall) +
#   aes(x=type, y=pct, group=province) +
#   geom_segment(aes(x=type,xend=type,y=pct,yend=pct),size=1, colour=wfp_blue) +
#   theme(panel.background = element_blank()) +
#   theme(panel.grid=element_blank()) +
#   theme(axis.ticks=element_blank()) +
#   theme(axis.text=element_blank()) +
#   theme(panel.border=element_blank()) +
#   xlab("") +
#   ylab("Percentage of eligible population")
#
# plot(p)

