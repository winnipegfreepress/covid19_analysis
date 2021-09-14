source_zips <- c(
  "data-raw-2021-07-02--13-37.zip",
  "data-raw-2021-07-03--12-46.zip",
  "data-raw-2021-07-04--21-10.zip",
  "data-raw-2021-07-05--13-04.zip",
  "data-raw-2021-07-06--22-18.zip",
  "data-raw-2021-07-07--14-08.zip",
  "data-raw-2021-07-08--17-06.zip",
  "data-raw-2021-07-09--12-53.zip",
  "data-raw-2021-07-11--15-21.zip",
  "data-raw-2021-07-12--15-43.zip",
  "data-raw-2021-07-13--14-01.zip",
  "data-raw-2021-07-14--13-42.zip",
  "data-raw-2021-07-15--13-01.zip",
  "data-raw-2021-07-16--12-58.zip",
  "data-raw-2021-07-18--12-29.zip",
  "data-raw-2021-07-19--13-05.zip",
  "data-raw-2021-07-20--13-02.zip",
  "data-raw-2021-07-21--13-08.zip",
  "data-raw-2021-07-22--12-48.zip",
  "data-raw-2021-07-23--12-58.zip",
  "data-raw-2021-07-26--12-50.zip",
  "data-raw-2021-07-27--13-31.zip",
  "data-raw-2021-07-28--12-59.zip",
  "data-raw-2021-07-29--23-52.zip",
  "data-raw-2021-07-30--12-45.zip",
  "data-raw-2021-08-03--23-13.zip",
  "data-raw-2021-08-04--13-40.zip",
  "data-raw-2021-08-06--15-33.zip",
  "data-raw-2021-08-09--13-32.zip",
  "data-raw-2021-08-10--13-28.zip",
  "data-raw-2021-08-11--12-45.zip",
  "data-raw-2021-08-12--12-34.zip",
  "data-raw-2021-08-16--16-16.zip",
  "data-raw-2021-08-21--22-38.zip",
  "data-raw-2021-08-22--00-18.zip",
  "data-raw-2021-08-23--16-38.zip",
  "data-raw-2021-08-25--14-42.zip",
  "data-raw-2021-08-26--12-45.zip",
  "data-raw-2021-08-27--13-23.zip",
  "data-raw-2021-08-30--12-51.zip",
  "data-raw-2021-08-31--12-40.zip",
  "data-raw-2021-09-01--19-02.zip",
  "data-raw-2021-09-02--13-01.zip",
  "data-raw-2021-09-03--12-38.zip",
  "data-raw-2021-09-08--13-04.zip",
  "data-raw-2021-09-14--12-01.zip"
)

# Create df based on what the JSON contains, empty it and then rbind in the while loop
data_vax <- readr::read_csv(unzip(dir_data_cache("data-raw-2021-09-14--12-01.zip"), "raw/Manitoba_COVID-19_Vaccine_Uptake_by_District.csv"))

districts_df_input <- jsonlite::fromJSON(here::here("data/raw/", "details-district", "2020-10-01-details-district.json"))
districts_df_input <- districts_df_input[["features"]][["attributes"]]
districts_df_input <- districts_df_input %>%
  clean_names() %>%
  mutate(
    date = as.Date("2020-10-01", "%Y-%m-%d"),
    total_cases = NA,
    object_id = NA
  )
districts_df <- slice(districts_df_input, 0)


for(zipped in source_zips){

  data <- readr::read_csv(unzip(dir_data_cache(zipped), "Manitoba_COVID-19_Vaccine_Uptake_by_District.csv"))

}






Manitoba_COVID_19_Vaccine_Uptake_by_District <- read_csv(dir_data_raw("Manitoba_COVID-19_Vaccine_Uptake_by_District.csv")) %>%
  clean_names() %>%
  select(-objectid, -shape_length, -shape_area) %>%
  mutate(
    rha = ifelse(rhacode == "SO", "Southern Health", rha),
    rha = factor(rha,
                 levels=c(
                   "Interlake-Eastern",
                   "Northern",
                   "Prairie Mountain Health",
                   "Southern Health",
                   "Winnipeg"
                 ))
  )


