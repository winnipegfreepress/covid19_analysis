#
# wfp_daily_hospitalization_total_active_tall_last <- wfp_daily_hospitalization_total_active_tall %>%
#   filter(date == max(date))
#
# final_date <- wfp_daily_hospitalization_total_active_tall_last %>% select(date) %>% head(1) %>% pull()
# final_icu_active <- wfp_daily_hospitalization_total_active_tall_last %>% filter(type=="ICU (active)") %>% select(cnt) %>% pull()
# final_icu_inactive <- wfp_daily_hospitalization_total_active_tall_last %>% filter(type=="ICU (inactive)") %>% select(cnt) %>% pull()
#
# final_nonicu_active <- wfp_daily_hospitalization_total_active_tall_last %>% filter(type=="Non-ICU (active)") %>% select(cnt) %>% pull()
# final_nonicu_inactive <- wfp_daily_hospitalization_total_active_tall_last %>% filter(type=="Non-ICU (inactive)") %>% select(cnt) %>% pull()

p_daily_hospitalization <- ggplot(wfp_daily_hospitalization_totals) +
  aes(x = date, y = active_hospital) +
  geom_area(aes(x = date, y = total_hospital), size = .25, colour="white", fill=nominalMuted_shade_0) +
  geom_area(aes(x = date, y = active_hospital), size = .25, colour="white", fill=nominalBold_shade_0) +
  geom_area(aes(x = date, y = total_icu), size = .25, colour="white", fill=nominalMuted_shade_3) +
  geom_area(aes(x = date, y = active_icu), size = .25, colour="white", fill=nominalBold_shade_3) +

  geom_text(data=wfp_daily_hospitalization_totals %>% filter(date == max(date)),
            stat="identity",
            aes(x=date + 3, y=total_hospital, label=paste(total_hospital, " in hospital", sep="")),
            colour=nominalMuted_shade_0,
            hjust=-.05, size=3.5, lineheight=1, fontface="bold"
  ) +

  geom_text(data=wfp_daily_hospitalization_totals %>% filter(date == max(date)),
            stat="identity",
            aes(x=date + 3, y=active_hospital, label=paste(active_hospital, " active in hospital", sep="")),
            colour=nominalBold_shade_0,
            hjust=-.03, size=3.5, lineheight=1, fontface="bold"
  ) +

  geom_text(data=wfp_daily_hospitalization_totals %>% filter(date == max(date)),
            stat="identity",
            aes(x=date + 3, y=total_icu, label=paste(total_icu, " in ICU", sep="")),
            colour=nominalMuted_shade_3,
            hjust=-.05, size=3.5, lineheight=1, fontface="bold"
  ) +

  geom_text(data=wfp_daily_hospitalization_totals %>% filter(date == max(date)),
            stat="identity",
            aes(x=date + 3, y=active_icu, label=paste(active_icu, " active in ICU", sep="")),
            colour=nominalBold_shade_3,
            hjust=-.03, size=3.5, lineheight=1, fontface="bold",
            vjust=1.3
  ) +

  # annotate("text",
  #          x=as.Date("2020-07-21"),
  #          y=30,
  #          label=wrap_text("Dec. 4: \n55 active and contagious COVID-19 cases reported in ICU.", 28),
  #          hjust=1, vjust=0.1, size=4,
  #          colour="#000000"
  # ) +
  #

  # annotate("text",
  #   x=as.Date("2020-08-21"),
  #   y=220,
  #   label=wrap_text("Dec. 4: 71 COVID-19 cases reported in ICU including \n55 active and contagious cases.", 28),
  #   hjust=1, vjust=0.1, size=4,
  #   colour="#000000"
  # ) +
#   geom_curve(data = data.frame(x = as.Date("2020-12-01"), y = 55,
#                                xend = as.Date("2020-08-28"), yend = 240),
#              mapping = aes(x = x,
#               y = y, xend = xend, yend = yend),
#              angle = 90L, colour = "black",
#              curvature = 0.25, arrow = structure(list(angle = 30, length = structure(0.1, class = "unit", valid.unit = 1L, unit = "inches"), ends = 1L, type = 1L), class = "arrow"),
#              inherit.aes = FALSE, show.legend = FALSE) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 500),
    breaks=seq(0,500,by=100),
    labels=scales::comma
  ) +
  scale_x_date(
    expand=c(0, 0),
    limits=c(as.Date("2020-03-01"), as.Date("2021-09-30")),
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
