
p_daily_cases_rha_cnt <- ggplot(dashboard_daily_status_manitoba %>%
                                 filter(date >= "2021-07-02" & date <= "2021-09-20")) +
  aes(
    x = date,
    y = daily_cases_7day,
    colour = rha,
    group = rha
  ) +
  geom_line(size = 1, alpha=.7) +
  geom_line(data=dashboard_daily_status_manitoba %>%
              filter(rha == "Southern"),
            size = 1, alpha=1) +
  geom_text(data=dashboard_daily_status_manitoba %>%
              filter(date == max(date)),
            aes(x = date,
                y = daily_cases_7day,
                group = rha,
                label=paste(rha, ": ", format(daily_cases_7day, digits=2), sep="")
            ),
            color="#000000", hjust=-.05,
            size = 4, alpha=1) +
  # scale_color_brewer(palette = "Set1", direction = 1) +
  scale_colour_manual(values=wfpPaletteNominalMuted) +
  scale_x_date(
    expand=c(0, 0),
    limits=as.Date(c("2021-06-30","2021-11-01")),
    date_breaks="1 month",
    labels=date_format("%b")
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 50)
  ) +
  labs(
    title=wrap_text("Daily cases of COVID-19 across Manitoba health regions", 70),
    subtitle=wrap_text("Seven-day moving average of new daily cases", 80),
    caption=wrap_text(toupper(paste("WINNIPEG FREE PRESS", " — SOURCE: ", "Manitoba Health", " (", "2021-09-22", ")",sep="")), 80),
    x="",
    y=""
  ) +
  minimal_theme() +
  theme(
    legend.position = "none"
  )



wfp_daily_cases_rha_cnt <- prepare_plot(p_daily_cases_rha_cnt)
ggsave_pngpdf(wfp_daily_cases_rha_cnt, "wfp_daily_cases_rha_cnt", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")





p_daily_cases_rha_capita <- ggplot(dashboard_daily_status_manitoba %>%
                                 filter(date >= "2021-07-02" & date <= "2021-09-20")) +
  aes(
    x = date,
    y = daily_cases_7day_100K,
    colour = rha,
    group = rha
  ) +
  geom_line(size = 1, alpha=.7) +
  geom_line(data=dashboard_daily_status_manitoba %>%
              filter(rha == "Southern"),
            size = 1, alpha=1) +
  geom_text(data=dashboard_daily_status_manitoba %>%
              filter(date == max(date)),
            aes(x = date,
                y = daily_cases_7day_100K,
                group = rha,
                label=paste(rha, ": ", format(daily_cases_7day_100K, digits=2), " cases/100K", sep="")
                ),
            color="#000000", hjust=-.05,
            size = 4, alpha=1) +
  # scale_color_brewer(palette = "Set1", direction = 1) +
  scale_colour_manual(values=wfpPaletteNominalMuted) +
  scale_x_date(
    expand=c(0, 0),
    limits=as.Date(c("2021-06-30","2021-11-01")),
    date_breaks="1 month",
    labels=date_format("%b")
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 20)
  ) +
  labs(
    title=wrap_text("Daily cases per capita of COVID-19 across Manitoba health regions", 70),
    subtitle=wrap_text("Seven-day moving average of new cases per 100,000 people", 80),
    caption=wrap_text(toupper(paste("WINNIPEG FREE PRESS", " — SOURCE: ", "Manitoba Health", " (", "2021-09-22", ")",sep="")), 80),
    x="",
    y=""
  ) +
  minimal_theme() +
  theme(
    legend.position = "none"
  )



wfp_daily_cases_rha_capita <- prepare_plot(p_daily_cases_rha_capita)
ggsave_pngpdf(wfp_daily_cases_rha_capita, "wfp_daily_cases_rha_capita", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

