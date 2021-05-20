
# Figure out today's week-year to filter out incomplete weeks
today=Sys.Date()
today_year=year(today)
today_week=isoweek(today)
today_week_year=paste(today_week, "-", today_year, sep="")


dashboard_weekly_cases_deaths_trimmed <- dashboard_weekly_cases_deaths %>%
  filter(week_year != today_week_year) %>%
  fill(weekly_cases_pct_change) %>%
  fill(weekly_deaths_pct_change)


# Select the last week to highlight alongside the %chg value
dashboard_weekly_cases_deaths_last_week <- dashboard_weekly_cases_deaths_trimmed %>%
  filter(week_year == (dashboard_weekly_cases_deaths_trimmed %>% filter(date==max(date)) %>% select(week_year) %>%  pull()))

# Did it increase or decrease?
weekly_cases_pct_change_last_week <- dashboard_weekly_cases_deaths_last_week %>%
  filter(!is.na(weekly_cases_pct_change)) %>%
  select(weekly_cases_pct_change) %>%
  pull()

pctchg_cases_str <- ifelse(weekly_cases_pct_change_last_week > 0, "increase", "decrease")


# Did it increase or decrease?
weekly_deaths_pct_change_last_week <- dashboard_weekly_cases_deaths_last_week %>%
  filter(!is.na(weekly_deaths_pct_change)) %>%
  select(weekly_deaths_pct_change) %>%
  pull()

pctchg_deaths_str <- ifelse(weekly_deaths_pct_change_last_week > 0, "increase", "decrease")


asof_date <- dashboard_weekly_cases_deaths_last_week %>% filter(date == max(date)) %>% select(date) %>% pull()
subtitle_str=paste("All reported cases as of", format(asof_date, "%B %d, %Y", sep=""))



p_weekly_cases_pct_chg <- plot_line_timeseries(
  dashboard_weekly_cases_deaths_trimmed,
  x_var=date,
  y_var=epi_cases,
  line_colour=wfp_blue, line_size=1,
  line_geom="step",
  title_str="Weekly cases of COVID-19 reported in Manitoba",
  subtitle_str=subtitle_str,
  x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="1 months",
  ymin=0, ymax=4000, y_units="%",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_weekly_cases_pct_chg <- p_weekly_cases_pct_chg +
  geom_text(data=dashboard_weekly_cases_deaths_trimmed %>% filter(!is.na(weekly_cases_pct_change)) %>% filter(date == max(date)),
            aes(x=date, y=epi_cases,
                label=wrap_text(paste(comma(weekly_cases_pct_change), "%", sep=""), 18)
            ),
            color="#000000", hjust=-.02, vjust=-2.35, size=7, fontface="bold"
  ) +
  geom_text(data=dashboard_weekly_cases_deaths_trimmed %>% filter(!is.na(weekly_cases_pct_change)) %>% filter(date == max(date)),
            aes(x=date, y=epi_cases,
                label=wrap_text(paste(pctchg_cases_str, sep=""), 18)
            ),
            color="#000000", hjust=-.02, vjust=-2.5, size=3.5, fontface="bold"
  ) +
  geom_text(data=dashboard_weekly_cases_deaths_trimmed %>% filter(!is.na(weekly_cases_pct_change)) %>% filter(date == max(date)),
            aes(x=date, y=epi_cases,
                label=wrap_text(paste(comma(epi_cases), " cases", sep=""), 25)
            ),
            color="#555555", hjust=-.02, vjust=-.5, size=3.5
  )



wfp_weekly_cases_pct_chg <- prepare_plot(p_weekly_cases_pct_chg)
ggsave_pngpdf(wfp_weekly_cases_pct_chg, "wfp_weekly_cases_pct_chg", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")



p_weekly_deaths_pct_chg <- plot_line_timeseries(
  dashboard_weekly_cases_deaths_trimmed,
  x_var=date,
  y_var=epi_deaths,
  line_colour=wfp_blue, line_size=1,
  line_geom="step",
  title_str="Weekly COVID-19 deaths reported in Manitoba",
  subtitle_str=subtitle_str,
  x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="1 months",
  ymin=0, ymax=150, y_units="%",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_weekly_deaths_pct_chg <- p_weekly_deaths_pct_chg +
  geom_text(data=dashboard_weekly_cases_deaths_trimmed %>% filter(!is.na(weekly_deaths_pct_change)) %>% filter(date == max(date)),
            aes(x=date, y=epi_deaths,
                label=wrap_text(paste(comma(weekly_deaths_pct_change), "%", sep=""), 18)
            ),
            color="#000000", hjust=-.02, vjust=-2.35, size=7, fontface="bold"
  ) +
  geom_text(data=dashboard_weekly_cases_deaths_trimmed %>% filter(!is.na(weekly_deaths_pct_change)) %>% filter(date == max(date)),
            aes(x=date, y=epi_deaths,
                label=wrap_text(paste(pctchg_deaths_str, sep=""), 18)
            ),
            color="#000000", hjust=-.02, vjust=-2.5, size=3.5, fontface="bold"
  ) +
  geom_text(data=dashboard_weekly_cases_deaths_trimmed %>% filter(!is.na(weekly_deaths_pct_change)) %>% filter(date == max(date)),
            aes(x=date, y=epi_deaths,
                label=wrap_text(paste(comma(epi_deaths), " deaths", sep=""), 25)
            ),
            color="#555555", hjust=-.02, vjust=-.5, size=3.5
  )



wfp_weekly_deaths_pct_chg <- prepare_plot(p_weekly_deaths_pct_chg)
ggsave_pngpdf(wfp_weekly_deaths_pct_chg, "wfp_weekly_deaths_pct_chg", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")


