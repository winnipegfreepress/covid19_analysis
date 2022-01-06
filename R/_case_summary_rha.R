
daily_deaths_manitoba <- dashboard_daily_status_manitoba %>%
  select(
    date,
    rha,
    daily_cases,
    cumulative_cases,
    active_cases,
    recoveries,
    deaths,
    pop_2019
  ) %>%
  mutate(
    deaths_daily = deaths - lag(deaths),
    deaths_per_capita = deaths / pop_2019 * 100000
  )



p_rha_deaths <- plot_line_timeseries(
  daily_deaths_manitoba,
  x_var=date,
  y_var=deaths,
  group_var=rha,
  line_colour=nominalMuted_shade_0,
  title_str="COVID-19 deaths in Manitoba's regional health authorities",
  # subtitle_str="",
  x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="3 months",
  ymin=0, ymax=1000, y_units="%",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_rha_deaths <- p_rha_deaths +
  geom_point(data=daily_deaths_manitoba %>% filter(date == max(date)),
             aes(x=date, y=deaths),
             color=nominalBold_shade_0, fill=nominalMuted_shade_1, size=1.5, alpha=1
  ) +
  geom_text(data=daily_deaths_manitoba %>% filter(date == max(date)),
            aes(x=as.Date(xmin_var) + 20, y=970,
                label=paste(
                  comma(cumulative_cases), " cases", "\n",
                  comma(deaths, accuracy=1), " deaths", "\n",
                  # comma(deaths_per_capita, accuracy=1), " deaths/100K", "\n",
                  sep="")
            ),
            color="#000000", hjust=.05, vjust=1, size=3.5
  ) +
  theme(
    strip.background=ggplot2::element_blank(),
    strip.text=ggplot2::element_text(size =13, hjust=0, face="bold"),
    panel.border=ggplot2::element_blank()
  ) +
  facet_wrap(.~rha)

wfp_rha_deaths <- prepare_plot(p_rha_deaths)
ggsave_pngpdf(wfp_rha_deaths, "wfp_rha_deaths", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")


