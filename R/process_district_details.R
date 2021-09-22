
dateStart <- as.Date("2020-10-01", format="%Y-%m-%d")
dateEnd <- Sys.Date() # as.Date("2021-09-21", format="%Y-%m-%d")


population_mb_2020 <- read_csv(dir_data_raw("population_mb_2020.csv")) %>%
  clean_names() %>%
  mutate(
    age_group=gsub("+", " plus", age_group, fixed=TRUE)

  )


# Create df based on what the JSON contains, empty it and then rbind in the while loop
districts_df_input <- jsonlite::fromJSON(dir_data_raw("details-district", "2020-11-01-details-district.json"))
districts_df_input <- districts_df_input[["features"]][["attributes"]]
districts_df_input <- districts_df_input %>%
  clean_names() %>%
  mutate(
    date=as.Date("2020-10-01", "%Y-%m-%d"),
    total_cases=NA,
    object_id=NA
  )
districts_df <- slice(districts_df_input, 0)


# Pull from JSON, add date column and stack the daily files
theDate <- dateStart


while (theDate <= dateEnd) {
  file_name <- paste(format(theDate, "%Y-%m-%d"), "-details-district.json", sep="")
  filepath <- dir_data_raw("details-district", file_name)
  print(filepath)

  if(file.exists(filepath)) {

    print(paste("\n\n EXISTS: ", filepath, sep=" "))

    districts_details_tmp <- jsonlite::fromJSON(filepath)
    districts_details_tmp <- districts_details_tmp[["features"]][["attributes"]]
    districts_details_tmp <- districts_details_tmp %>%
      clean_names() %>%
      mutate(
        date=as.Date(theDate, "%Y-%m-%d")
      )

    if ("total_cases" %in% colnames(districts_details_tmp)) {
      districts_details_tmp <- districts_details_tmp %>% rename(value=total_cases)
    }

    if ("object_id" %in% colnames(districts_details_tmp)) {
      districts_details_tmp <- districts_details_tmp %>% select(-object_id)
    }

    write_csv(districts_details_tmp, here::here(dir_data_out, paste(file_name, ".csv", sep="")))
    districts_df <- rbind(districts_df, districts_details_tmp)

  }
  else{
    print(paste("DOES NOT EXIST: ", filepath, sep=" "))
  }

  # Sys.sleep(.5)
  theDate <- theDate + 1

}

write_csv(districts_df, dir_data_processed(paste("COVID19_district_details.csv", sep="")))
write_feather(districts_df, dir_data_processed(paste("COVID19_district_details.feather", sep="")))


