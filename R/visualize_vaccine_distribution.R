
COVID19_MB_vaccine_distribution__Manitoba <- COVID19_MB_vaccine_distribution %>% filter(province == "Manitoba")

p_vaccine_distribution_cumsum <-  ggplot(COVID19_MB_vaccine_distribution__Manitoba) +
  aes(x=date, y=cumulative_dvaccine) +
  geom_area(fill=nominalMuted_shade_0, colour=wfp_blue, size=.5) +
  geom_text(data=COVID19_MB_vaccine_distribution__Manitoba %>% filter(date==max(date)),
    aes(x=date, y=cumulative_dvaccine, label=paste(comma(cumulative_dvaccine, accuracy=1), sep="")),
    color=nominalBold_shade_1,
    fill=nominalBold_shade_1,
    size=4,
    hjust=1,
    vjust=-1,
    direction="y",
    segment.color="#999999",
    segment.size=.2,
    show.legend=FALSE
  ) +
  scale_x_date(
    expand=c(0, 0),
    limits=c(as.Date("2020-12-01"),as.Date("2021-04-30")),
    date_breaks="1 month",
    labels=date_format("%B")
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 500000),
    labels=scales::comma
  ) +
  labs(
    title="COVID-19 vaccine doses distributed to Manitoba",
    subtitle="",
    caption=toupper(paste("Manitoba Health COVID-19 Bulletin", " (", last_update_timestamp, ")", sep="")),
    x="",
    y="",
    fill=""
  ) +
  minimal_theme()

p_vaccine_distribution_cumsum <- prepare_plot(p_vaccine_distribution_cumsum)
ggsave_pngpdf(p_vaccine_distribution_cumsum, "p_vaccine_distribution_cumsum", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")


p_vaccine_distribution_daily <- ggplot(COVID19_MB_vaccine_distribution__Manitoba) +
  aes(x=date, weight=dvaccine) +
  geom_bar(fill=wfp_blue) +
  scale_x_date(
    expand=c(0, 0),
    limits=c(as.Date("2020-12-01"),as.Date("2021-04-30")),
    date_breaks="1 month",
    labels=date_format("%B")
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 30000),
    labels=scales::comma
  ) +
  labs(
    title="",
    subtitle="",
    caption="",
    x="",
    y="",
    fill=""
  ) +
  minimal_theme()



p_vaccine_distribution_daily <- prepare_plot(p_vaccine_distribution_daily)
ggsave_pngpdf(p_vaccine_distribution_daily, "p_vaccine_distribution_daily", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

