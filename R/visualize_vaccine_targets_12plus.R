
# PLOT
p_vaccine_targets <- ggplot(phac_covid_vaccine_mb_projections) +
  annotate("text",
           x=as.Date("2020-12-05"),
           y=mb_12plus_population_2020estimate_70pct,
           label=paste("Vaccination target\n70% of eligible Manitobans age 12 or older", sep=""),
           hjust=0, vjust=.5, size=3.5, lineheight=1.2,
           colour="#222222"
  ) +
  annotate("segment",
           x=as.Date("2020-12-01"),
           y=mb_12plus_population_2020estimate_70pct,
           xend=as.Date("2021-07-31"),
           yend=mb_12plus_population_2020estimate_70pct,
           size=.5,
           alpha= 1,
           linetype="solid",
           colour=nominalBold_shade_1
  ) +
  geom_ribbon(
    data=phac_covid_vaccine_mb_projections %>% filter(date <= maxdate_COVID19_MB_first_second_vaccine_dose),
    aes(x=date, ymin=0, ymax=cumulative_first_doses),
    fill=wfp_blue, alpha=1) +

  annotate("text", x=as.Date(maxdate_COVID19_MB_first_second_vaccine_dose), y=cnt_first_dose, label=wrap_text(paste(round(pct_first_dose, digits=1), "% of eligible population", sep=""), 40), hjust=1, vjust=-2.5, size=4, lineheight=1, fontface="bold", colour="#222222") +
  annotate("text", x=as.Date(maxdate_COVID19_MB_first_second_vaccine_dose), y=cnt_first_dose, label=wrap_text(paste(comma(cnt_first_dose), " first doses", sep=""), 20), hjust=1, vjust=-1, size=3.5, lineheight=1, colour="#222222" ) +
  geom_line( data=phac_covid_vaccine_mb_projections %>% filter(date >= maxdate_COVID19_MB_first_second_vaccine_dose), aes(x=date, y=cumsum_daily_doses_7dayavg_projected), stat="identity", size=.5, alpha=1, linetype="dashed", colour=wfp_blue ) +
  # geom_point( data=phac_covid_vaccine_mb_projections %>% filter(cumsum_daily_doses_7dayavg_projected > mb_12plus_population_2020estimate_70pct - phac_covid_vaccine_7day_avg_doses) %>% filter(cumsum_daily_doses_7dayavg_projected < mb_12plus_population_2020estimate_70pct + phac_covid_vaccine_7day_avg_doses) %>% head(1) , aes(x=date, y=cumsum_daily_doses_7dayavg_projected), stat="identity", size=2, shape=21, colour=nominalBold_shade_1, fill=nominalBold_shade_1 ) +
  # geom_text( data=phac_covid_vaccine_mb_projections %>% filter(cumsum_daily_doses_7dayavg_projected > mb_12plus_population_2020estimate_70pct - phac_covid_vaccine_7day_avg_doses) %>% filter(cumsum_daily_doses_7dayavg_projected < mb_12plus_population_2020estimate_70pct + phac_covid_vaccine_7day_avg_doses) %>% head(1) , aes(x=date - 3, y=cumsum_daily_doses_7dayavg_projected, label=paste("70% target", sep="") ), stat="identity", fontface="bold", size=4, lineheight=.9, hjust=1, vjust=0 ) +

  # annotate("text",
  #   x = as.Date(maxdate_COVID19_MB_first_second_vaccine_dose + 1),
  #   y = cnt_first_dose + 130000,
  #   label = wrap_text(paste(comma(phac_covid_vaccine_7day_avg_doses), "daily doses", sep = " "), 50),
  #   hjust = -.44, vjust = .25, size = 4,
  #   fontface = "bold",
  #   lineheight = 1,
  #   colour = "#222222"
  # ) +
  #   annotate("text",
  #     x = as.Date(maxdate_COVID19_MB_first_second_vaccine_dose + 1),
  #     y = cnt_first_dose + 130000,
  #     label = wrap_text(paste("Seven-day average", sep = " "), 50),
  #     hjust = -.49, vjust = 2, size = 3.5,
  #     lineheight = 1,
  #     colour = "#222222"
  #   ) +
  scale_x_date(
    expand=c(0, 0),
    limits=as.Date(c("2020-12-01", "2021-07-31")),
    date_breaks="1 month",
    labels=date_format("%b")
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 1000000),
    labels=label_number_si(unit="")
  ) +
  labs(
    title=wrap_text("COVID-19 vaccinations in Manitoba", 65),
    subtitle=wrap_text(subtitle_str, 88),
    caption=wrap_text(toupper(paste("Winnipeg Free Press", " — SOURCE: ", "Manitoba Health Vaccine Dashboard", " (", last_update_timestamp, ")", sep="")), 80),
    x="",
    y="",
    fill=""
  ) +
  minimal_theme()



p_vaccine_targets_5_12_20K <- p_vaccine_targets +
  # geom_line(
  #   data=phac_covid_vaccine_mb_projections,
  #   aes(x=date, y=cumsum_daily_doses_20K_projected),
  #   stat="identity",
  #   size=2,
  #   alpha=1,
  #   linetype="dotted",
  #   colour=nominalMuted_shade_2
  # ) +
  geom_text(
    aes(x=as.Date("2021-05-05"),
        y=725000,
        label=paste("12K doses a day", sep="")
    ),
    size=3, hjust=-1, lineheight=1, colour="#000000"
  )



wfp_vaccine_targets <- prepare_plot(p_vaccine_targets)
ggsave_pngpdf(wfp_vaccine_targets, "wfp_vaccine_targets", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

wfp_vaccine_targets_5_12_20K <- prepare_plot(p_vaccine_targets_5_12_20K)
ggsave_pngpdf(wfp_vaccine_targets_5_12_20K, "wfp_vaccine_targets_5_12_20K", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
