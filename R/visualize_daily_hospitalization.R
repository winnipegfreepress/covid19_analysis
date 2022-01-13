
y_max <- 600

p_daily_hospitalization <- ggplot(wfp_daily_hospitalization_totals) +
  aes(x = date, y = active_hospital) +
  geom_area(aes(x = date, y = total_hospital), size = .25, colour="white", fill=nominalMuted_shade_0) +
  geom_area(aes(x = date, y = active_hospital), size = .25, colour="white", fill=nominalBold_shade_0) +
  geom_area(aes(x = date, y = total_icu), size = .25, colour="white", fill=nominalMuted_shade_3) +
  geom_area(aes(x = date, y = active_icu), size = .25, colour="white", fill=nominalBold_shade_3) +

  geom_text(data=wfp_daily_hospitalization_totals %>% filter(date == max(date)),
            stat="identity",
            aes(x=date - 120, y=y_max - 10, label=paste(total_hospital, " in hospital", sep="")),
            colour=nominalMuted_shade_0,
            hjust=-.05, size=3.5, lineheight=1, fontface="bold"
  ) +

  geom_text(data=wfp_daily_hospitalization_totals %>% filter(date == max(date)),
            stat="identity",
            aes(x=date - 120, y=y_max - 35, label=paste(active_hospital, " active in hospital", sep="")),
            colour=nominalBold_shade_0,
            hjust=-.03, size=3.5, lineheight=1, fontface="bold"
  ) +

  geom_text(data=wfp_daily_hospitalization_totals %>% filter(date == max(date)),
            stat="identity",
            aes(x=date - 120, y_max - 60, label=paste(total_icu, " in ICU", sep="")),
            colour=nominalMuted_shade_3,
            hjust=-.05, size=3.5, lineheight=1, fontface="bold"
  ) +

  geom_text(data=wfp_daily_hospitalization_totals %>% filter(date == max(date)),
            stat="identity",
            aes(x=date - 120, y_max - 85, label=paste(active_icu, " active in ICU", sep="")),
            colour=nominalBold_shade_3,
            hjust=-.03, size=3.5, lineheight=1, fontface="bold"
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, y_max),
    breaks=seq(0,y_max,by=100),
    labels=scales::comma
  ) +
  scale_x_date(
    expand=c(0, 0),
    limits=c(as.Date(xmin_var), as.Date(xmax_var)),
    date_breaks="1 month",
    date_minor_breaks="1 month",
    labels=date_format("%b")
  ) +
  labs(
    title = wrap_text("Hospitalization and ICU admissions of COVID-19 cases", 70),
    subtitle = wrap_text("Cases sent out of province for hospitalization and those sent home for the virtual hospitalization program are excluded. Reported COVID-19 hospitalization and ICU counts are limited to active and contagious cases prior to late December.", 85),
    caption = paste("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH (", last_update_timestamp, ")", sep = ""),
    x = "",
    y = "",
    fill=""
  ) +
  guides(colour=FALSE) +
  minimal_theme() +
  theme(
    legend.background = element_rect(fill="white", size=0.5, linetype="solid", colour ="white"),
    legend.title=ggplot2::element_text(face="bold"),
    legend.position=c(.4, .99),
    legend.justification=c("right", "top"),
    legend.box.just="right",
    legend.margin=margin(1,5,1,5),
    legend.spacing.y = unit(.5, 'cm')
  )


wfp_daily_hospitalization <- prepare_plot(p_daily_hospitalization)

ggsave_pngpdf(wfp_daily_hospitalization, "wfp_daily_hospitalization", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(wfp_daily_hospitalization, "wfp_covid_hospitalization_type", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")



ggsave_pngpdf(wfp_daily_hospitalization, "wfp_daily_hospitalization_sq", width_var=8.66, height_var=8.66, dpi_var=300, scale_var=1, units_var="in")
