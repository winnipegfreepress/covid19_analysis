#
# # Loop through cached zip file, unzip and process the district uptake data
#
#
# cache_dir <- here::here("data/cache")
# cache_files <- list.files(path=cache_dir, pattern='data-raw', full.names = TRUE)
#
#
# # Create dataframe based on source data.
# # We bind rows of data to this after flushing contents to get a blank df
# Manitoba_COVID_19_Vaccine_Uptake_by_District_timeseries <- read_csv(dir_data_raw("Manitoba_COVID-19_Vaccine_Uptake_by_District.csv")) %>%
#   clean_names() %>%
#   select(-objectid, -shape_length, -shape_area) %>%
#   mutate(
#     rha = ifelse(rhacode == "SO", "Southern Health", rha),
#     rha = factor(rha,
#                  levels=c(
#                    "Interlake-Eastern",
#                    "Northern",
#                    "Prairie Mountain Health",
#                    "Southern Health",
#                    "Winnipeg"
#                  ))
#   )
#
# Manitoba_COVID_19_Vaccine_Uptake_by_District_timeseries <- slice(Manitoba_COVID_19_Vaccine_Uptake_by_District_timeseries, 0)
#
#
#
#
# for (file_path in cache_files){
#   unzip(file_path, overwrite = TRUE, exdir = dir_data_cache("uptake_timeseries"))
#
#   # uptake is newish, test for presence of file before erroring out
#   if(file.exists(dir_data_cache("uptake_timeseries/raw", "Manitoba_COVID-19_Vaccine_Uptake_by_District.csv"))){
#
#     cat(file_path)
#     cat("Uptake file exists, processing")
#
#     tmp_Manitoba_COVID_19_Vaccine_Uptake_by_District <- read_csv(dir_data_cache("uptake_timeseries/raw", "Manitoba_COVID-19_Vaccine_Uptake_by_District.csv")) %>%
#       clean_names() %>%
#       select(-objectid, -shape_length, -shape_area) %>%
#       mutate(
#         rha = ifelse(rhacode == "SO", "Southern Health", rha),
#         rha = factor(rha,
#                      levels=c(
#                        "Interlake-Eastern",
#                        "Northern",
#                        "Prairie Mountain Health",
#                        "Southern Health",
#                        "Winnipeg"
#                      ))
#       )
#
#     Manitoba_COVID_19_Vaccine_Uptake_by_District_timeseries <-
#       rbind(
#         Manitoba_COVID_19_Vaccine_Uptake_by_District_timeseries,
#         tmp_Manitoba_COVID_19_Vaccine_Uptake_by_District
#       )
#
#   }
#   else{
#     cat("No uptake file for this date")
#   }
#
#
# }

# View(Manitoba_COVID_19_Vaccine_Uptake_by_District_timeseries)

Manitoba_COVID_19_Vaccine_Uptake_by_District_timeseries_BAK <- Manitoba_COVID_19_Vaccine_Uptake_by_District_timeseries

Manitoba_COVID_19_Vaccine_Uptake_by_District_timeseries <- Manitoba_COVID_19_Vaccine_Uptake_by_District_timeseries %>%
    distinct() %>%
    mutate(
      date = as.Date(date)
    )



p_vaccine_uptake_timeseries <- ggplot(Manitoba_COVID_19_Vaccine_Uptake_by_District_timeseries) +
  aes(x = date, y = uptake_1, group = rhadname) +
  annotate("text",
           x=as.Date("2021-06-22"),
           y=95,
           label=wrap_text("June 22/23: Manitoba begins using 12+ population counts in data reporting", 75),
           hjust=-.04, vjust=-.15, size=3,
           colour="#000000"
  ) +
  annotate("segment",
           x=as.Date("2021-06-22"),
           y=0,
           xend=as.Date("2021-06-22"),
           yend=100, size=.25,
           linetype="dotted",
           colour="#777777"
  ) +
  geom_line(size=.25, colour=nominalMuted_shade_1, alpha=.6) +
  geom_line(
    data=Manitoba_COVID_19_Vaccine_Uptake_by_District_timeseries %>%
      filter(rhadname %in% c("Stanley", "Steinbach")) ,
    aes(x = date, y = uptake_1, group = rhadname),
    colour=wfp_blue,
    size=.75
  ) +
  geom_text(
    data=Manitoba_COVID_19_Vaccine_Uptake_by_District_timeseries %>%
      filter(rhadname %in% c("Stanley", "Steinbach")) %>% filter(date==max(date)),
    aes(x = date, y = uptake_1, group = rhadname, label=paste(rhadname, ": ", uptake_1, "%", sep="")),
    hjust=-.15,
    fontface = "bold",
    size=3
  ) +


  scale_x_date(
    expand=c(0, 0),
    limits=as.Date(c("2021-06-10", "2021-07-20")),
    date_breaks="2 weeks",
    labels=date_format("%B %d")
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 100),
    labels=function(x) {
      ifelse(x == 100, paste(x, "%", sep=""), x)
    }
  ) +
  labs(
    title=wrap_text("COVID-19 vaccine uptake in Manitoba health districts", 65),
    subtitle="First dose vaccinations among eligible Manitobans age 12 or older",
    caption=
      paste(toupper("Winnipeg Free Press"), " — SOURCE: ", toupper("Manitoba Health Vaccine Dashboard"), sep="")
    ,
    x="",
    y="",
    fill=""
  ) +
  minimal_theme()



wfp_vaccine_uptake_timeseries <- prepare_plot(p_vaccine_uptake_timeseries)
ggsave_pngpdf(wfp_vaccine_uptake_timeseries, "wfp_vaccine_uptake_timeseries", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
