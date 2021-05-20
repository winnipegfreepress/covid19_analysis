
districts_df_no_all <- districts_df %>%
  filter(rha != 'All') %>%
  filter(area != area_name)

write_csv(districts_df_no_all, dir_data_processed(paste("districts_df_no_all.csv", sep = "")))

districts_northern__cross_lake <- districts_df_no_all %>%
  filter(area_name == 'Cross Lake/Pimicikamak CN') %>%
  select(
    date,
    last_update,
    rha,
    area,
    area_name,
    value,
    active_cases,
    recovered,
    deaths,
    rate
  ) %>%
  arrange(date) %>%
  mutate(
    new_daily = value - lag(value)
  )


p_cross_lake_cases <- ggplot(districts_df_no_all) +
  aes(x = date, y = rate, group = area_name) +
  geom_line(size = .5, alpha=.5, color=nominalMuted_shade_0) +
  geom_line(data=districts_northern__cross_lake,
            aes(x = date, y = rate),
            size = 1, alpha=1, color=wfp_blue) +
  geom_text(
    data=districts_northern__cross_lake %>%  filter(date==max(date)),
    aes(x = date, y = rate, label=paste(
      "Cross Lake/", "\n", "Pimicikamak CN", "\n", comma(rate), " cases per", "\n", "100K people"
      , sep="")),
    hjust=-.05, vjust=.75, size=3.5
  ) +
  geom_point(
    data=districts_northern__cross_lake %>%  filter(date==max(date)),
    aes(x = date, y = rate),
    size=1.5, color=wfp_blue
  ) +
  scale_x_date(
    expand = c(0, 0),
    limits = c(as.Date("2020-11-01"), as.Date("2021-03-15")),
    date_breaks = "1 month",
    date_minor_breaks="1 day",
    labels = date_format("%b")
  ) +
  scale_y_continuous(expand = c(0, 0), limits = c(10, 20000), labels = scales::comma) +
  labs(
    title = wrap_text("COVID-19 cases per 100,000 people in Manitoba's health districts", 70),
    subtitle=wrap_text("The infection rate in Cross Lake/Pimicikamak CN has increased by 86.53 per cent in the previous 10 days", 85),
    caption = wrap_text(paste("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH (2020-02-22)", sep = ""), 110),
    x = "",
    y = "",
    fill=wrap_text(paste("COVID-19 vaccinations", sep=""), 30)
  ) +
  minimal_theme() +
  theme(
    legend.title=element_blank(),
    legend.position = "bottom",
    # panel.grid.major.x = ggplot2::element_blank(),
    # panel.grid.major.y = ggplot2::element_blank(),
    # panel.grid.minor.x = ggplot2::element_blank(),
    # panel.grid.minor.y = ggplot2::element_blank(),
    # axis.ticks.y = element_blank()
  )



wfp_cross_lake_cases <- prepare_plot(p_cross_lake_cases)
ggsave(dir_plots('wfp_cross_lake_cases.png'), plot=wfp_cross_lake_cases, scale=1, width=8.66, height=6, units = "in", dpi = 300, limitsize = TRUE )

