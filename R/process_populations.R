population_provinces_2020 <- read_csv(dir_data_raw("population_provinces_2020.csv")) %>%
  clean_names()

population_provinces_2021Q1 <- read_csv(dir_data_raw("population_provinces_2021Q1.csv")) %>%
  clean_names() %>%
  rename(
    province=geography,
    population=q1_2021
  ) %>%
  mutate(
    reference_period=as.Date("2021-03-31")
  ) %>%
  select(
    "reference_period",
    "province",
    "population"
  )

manitoba_health_districts_populations <- read_csv(dir_data_raw("wfp_manitoba_health_districts_populations.csv")) %>%
  clean_names() %>%
  rename( pop_2015=x2015, pop_2016=x2016, pop_2017=x2017, pop_2018=x2018, pop_2019=x2019 ) %>%
  mutate(
    rha=str_trim(rha),
    rha=gsub(" Health Region", "", rha, fixed=TRUE),
    rha=gsub(" Region", "", rha, fixed=TRUE),
    rha=gsub("Prairie Mountain", "Prairie Mountain Health", rha, fixed=TRUE),
    # district=gsub("Cartier/St. Francgois Xavier", "Cartier/St. François Xavier", rha, fixed=TRUE),
    # district=gsub("Cartier/St. Francgois Xavier", "Cartier/St. François Xavier", rha, fixed=TRUE),

    rha_zone=str_trim(rha_zone),
    district=str_trim(district),
    pop_2015=str_trim(pop_2015),
    pop_2016=str_trim(pop_2016),
    pop_2017=str_trim(pop_2017),
    pop_2018=str_trim(pop_2018),
    pop_2019=str_trim(pop_2019)
  ) %>%
  mutate( pop_2015=as.numeric(pop_2015), pop_2016=as.numeric(pop_2016), pop_2017=as.numeric(pop_2017), pop_2018=as.numeric(pop_2018), pop_2019=as.numeric(pop_2019) )

manitoba_health_regions_populations <- manitoba_health_districts_populations %>%
  group_by(rha) %>%
  summarize(
    pop_2019=sum(pop_2019, na.rm=TRUE)
  ) %>%
  ungroup() %>%
  mutate(
    rha=ifelse(rha=="Prairie Mountain Health", "Prairie Mountain",
                 ifelse(rha=="Southern Health-Santé Sud", "Southern",
                        rha
                 ))
  )

population_manitoba_2020 <- population_provinces_2020 %>% filter(province =="Manitoba") %>% select(population) %>% pull()

MB_age_group_pops <- read_csv(dir_data_raw("MB_age_group_pops.csv")) %>%
  clean_names()

MB_pop_estimates_2020_statcan_17_10_0005_01 <- read_csv(dir_data_raw("MB_pop_estimates_2020_statcan_17_10_0005_01.csv")) %>%
  clean_names()

population_provinces_18plus_2021Q2 <- read_csv(dir_data_raw("population_provinces_18plus_2021Q2.csv")) %>%
  clean_names() %>%
  rename(
    province=geography,
    population=population_18plus_2020q2
  ) %>%
  mutate(reference_period=as.Date("2020-06-30")) %>%
  select("reference_period", "province", "population")


write_feather(population_provinces_2020, dir_data_processed("population_provinces_2020.feather"))
write_feather(manitoba_health_regions_populations, dir_data_processed("manitoba_health_regions_populations.feather"))
write_feather(manitoba_health_districts_populations, dir_data_processed("manitoba_health_districts_populations.feather"))
write_feather(MB_age_group_pops, dir_data_processed("MB_age_group_pops.feather"))
write_feather(MB_pop_estimates_2020_statcan_17_10_0005_01, dir_data_processed("MB_pop_estimates_2020_statcan_17_10_0005_01.feather"))
write_feather(population_provinces_18plus_2021Q2, dir_data_processed("population_provinces_18plus_2021Q2.feather"))
