phac_daily_raw <- read_csv(dir_data_raw('phac_daily.csv')) %>%
 mutate(
   date=format(as.Date(date, format="%d-%m-%Y"), "%Y-%m-%d"),
   province=prname
 ) %>%
 left_join(population_provinces_2020, by=c("province"="province")) %>%
 mutate(
   total_reported_100K=numtotal / population * 100000,
   deaths_reported_100K=numdeaths / population * 100000,
 )



 write_feather(phac_daily_raw, dir_data_processed("phac_daily.feather"))
 write_csv(phac_daily_raw, dir_data_processed("phac_daily.csv"))
