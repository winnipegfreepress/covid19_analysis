
manitoba_COVID_19_Daily_Cases_by_Status_and_RHA <- read_csv("data/raw/Manitoba_COVID-19_–_Daily_Cases_by_Status_and_RHA.csv") %>%
  clean_names %>%
  mutate(
    date=gsub("05:00:00+00", "", date, fixed=TRUE),
    date=gsub("06:00:00+00", "", date, fixed=TRUE),
    date=as.Date(date)
  ) %>%
  arrange(
    date
  )


manitoba_COVID_19_Daily_Cases_by_Status_and_RHA_ALL <- manitoba_COVID_19_Daily_Cases_by_Status_and_RHA %>%
  filter(rha == "All") %>%
  mutate(
    daily_deaths=deaths - lag(deaths)
  )

# str(manitoba_COVID_19_Daily_Cases_by_Status_and_RHA_ALL)
# View(manitoba_COVID_19_Daily_Cases_by_Status_and_RHA_ALL)

p_mb_daily_deaths <- plot_bar_timeseries(
  manitoba_COVID_19_Daily_Cases_by_Status_and_RHA_ALL,
  x_var=date,
  y_var=daily_deaths,
  colour_var="",
  fill_var="",
  group_var="",
  bar_colour=wfp_blue,
  title_str="Daily COVID-19 deaths reported in Manitoba",
  subtitle_str="", x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="1 month",
  ymin=0, ymax=30, y_units="",
  source_str="Manitoba Health, COVID-19 Dashboard", lastupdate_str=last_update_timestamp
)

p_mb_daily_deaths <- p_mb_daily_deaths +
  annotate("text",
           x=as.Date("2020-12-08"),
           y=24,
           label=wrap_text("Dec 8: Manitoba records a record 18 daily COVID-19 deaths", 25),
           hjust=1, vjust=0.8, size=4,
           colour="#000000"
  )

wfp_mb_daily_deaths <- prepare_plot(p_mb_daily_deaths)
ggsave_pngpdf(wfp_mb_daily_deaths, "wfp_mb_daily_deaths", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
