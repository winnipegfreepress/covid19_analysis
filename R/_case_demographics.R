
start <- as.Date("2020-09-14",format="%Y-%m-%d")
end <- as.Date("2021-05-26",format="%Y-%m-%d")
importJSON <- "None" # None/Full

# THIS TAKES A FEW MINUTES, READ THE CSV UNLESS IT'S THE FIRST RUN OF THE DAY
# Create df based on what the JSON contains then rbind in the while loop

# Pull from JSON and stack the dates
# Oct 4 and 10 are wrong in this b/c column names
# change halfway through the month

if(importJSON == "Full"){

  theDate <- start

  demographics_df_sample <- jsonlite::fromJSON(dir_data_raw( "demographic_heatmap/2020-10-01-demographics-rha.json"))
  demographics_df_sample <- demographics_df_sample[["features"]][["attributes"]]
  demographics_df_sample <- demographics_df_sample %>%
    clean_names() %>%
    mutate(
      date = as.Date("2020-10-01", "%Y-%m-%d"),
      total_cases = NA,
      object_id = NA
    )
  demographics_df <- slice(demographics_df_sample, 0)
  # demographics_df <- demographics_df

  while (theDate <= end){

    file_name <- paste("/demographic_heatmap/", format(theDate,"%Y-%m-%d"), "-demographics-rha.json", sep="")
    print(file_name)

    demographics_rha_tmp <- jsonlite::fromJSON(dir_data_raw(file_name))

    # demographics_rha_tmp <- jsonlite::fromJSON(here::here(dir_data_raw, file_name))
    demographics_rha_tmp <- demographics_rha_tmp[["features"]][["attributes"]]
    demographics_rha_tmp <- demographics_rha_tmp %>%
      clean_names() %>%
      mutate(
        date = as.Date(theDate, "%Y-%m-%d")
      )

    if("total_cases" %in% colnames(demographics_rha_tmp)){
      demographics_rha_tmp <- demographics_rha_tmp %>% rename( value = total_cases )
    }

    if("object_id" %in% colnames(demographics_rha_tmp)){
      demographics_rha_tmp <- demographics_rha_tmp %>% select(-object_id)
    }

    demographics_df <- rbind(demographics_df, demographics_rha_tmp)

    Sys.sleep(.25)
    theDate <- theDate + 1

  }

  write_csv(demographics_df, dir_data_out(paste("demographics_df", '.csv', sep='')))

}

dashboard_demographics <- read_csv(dir_data_out("demographics_df.csv"))

MB_pop_estimates_2020 <- MB_pop_estimates_2020_statcan_17_10_0005_01 %>%
  group_by(age_group_mb) %>%
  summarize(total = sum(population_2020est)) %>%
  mutate(
    age_group_mb = ifelse(age_group_mb == "100+", "99+", age_group_mb)
  )

dashboard_demographics_allrha <- read_csv(dir_data_out("demographics_df.csv")) %>%
  filter(rha == "All") %>%
  select(-rha) %>%
  pivot_wider(names_from = gender, values_from = value) %>%
  clean_names() %>%
  mutate(
    total_cases = male + female
  ) %>%
  select(
    -female, -male
  ) %>%
  pivot_wider(
    names_from="age_group",
    names_prefix = "age_",
    values_from="total_cases"
  )


