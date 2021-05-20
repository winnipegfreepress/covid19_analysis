
wfp_daily_hospitalization_total_active_tall_last <- wfp_daily_hospitalization_total_active_tall %>%
  filter(date == max(date))

final_date <- wfp_daily_hospitalization_total_active_tall_last %>% select(date) %>% head(1) %>% pull()
final_icu_active <- wfp_daily_hospitalization_total_active_tall_last %>% filter(type=="ICU (active)") %>% select(cnt) %>% pull()
final_icu_inactive <- wfp_daily_hospitalization_total_active_tall_last %>% filter(type=="ICU (inactive)") %>% select(cnt) %>% pull()

final_nonicu_active <- wfp_daily_hospitalization_total_active_tall_last %>% filter(type=="Non-ICU (active)") %>% select(cnt) %>% pull()
final_nonicu_inactive <- wfp_daily_hospitalization_total_active_tall_last %>% filter(type=="Non-ICU (inactive)") %>% select(cnt) %>% pull()



p_daily_hospitalization <- plot_bar_stack(
  wfp_daily_hospitalization_total_active_tall,
  x_var=date,
  y_var=cnt,
  colour_var=type,
  fill_var=type,
  group_var="",
  bar_colour=nominalMuted_shade_0,
  title_str="Hospitalizations and ICU admissions of COVID-19 cases",
  subtitle_str="Reported COVID-19 hospitalization counts limited to active and contagious cases prior to late December", x_str="", y_str="",
  xmin=as.Date("2020-03-01"), xmax= final_date + 60, xformat="%b", x_units="1 month",
  ymin=0, ymax=500, y_units="",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_daily_hospitalization <- p_daily_hospitalization +
  # geom_point(data=wfp_daily_totals_last_date,
  #   stat="identity",
  #   aes(x=date, y=total_hospital),
  #   color="#ffffff",
  #   fill=nominalBold_shade_0,
  #   shape=21,
  #   size=2.5
  # ) +
  # geom_point(data=wfp_daily_totals_last_date,
  #   stat="identity",
  #   aes(x=date, y=total_icu),
  #   color="#ffffff",
  #   fill=nominalBold_shade_1,
  #   shape=21,
  #   size=2.5
  # ) +
#
# geom_text(data=wfp_daily_hospitalization_total_active_tall_last,
#   stat="identity",
#   aes(x=date + 98, y=cnt, label=paste(type, " ", cnt, sep="")),
#   color="black",
#   hjust=1,
#   size=3.5
# ) +

  # annotate("text",
  #   x=as.Date("2020-10-28"),
  #   y=275,
  #   label=wrap_text("Reported COVID-19 hospitalization counts limited to active and contagious cases prior to late December", 42),
  #   hjust=1, size=3.5,
  #   colour="#000000"
  # ) +

  annotate("text",
    x=as.Date("2020-07-21"),
    y=30,
    label=wrap_text("Dec. 4: \n55 active and contagious COVID-19 cases reported in ICU.", 28),
    hjust=1, vjust=0.1, size=4,
    colour="#000000"
  ) +

  geom_curve(data = data.frame(x = as.Date("2020-12-01"), y = 55,
                               xend = as.Date("2020-07-28"), yend = 55),
             mapping = aes(x = x,
              y = y, xend = xend, yend = yend),
             angle = 90L, colour = "black",
             curvature = 0.25, arrow = structure(list(angle = 30, length = structure(0.1, class = "unit", valid.unit = 1L, unit = "inches"), ends = 1L, type = 1L), class = "arrow"),
             inherit.aes = FALSE, show.legend = FALSE) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 500),
    breaks=seq(0,500,by=100),
    labels=scales::comma
  ) +
  scale_colour_manual(
    values=c(
      "Non-ICU (inactive)"=nominalMuted_shade_0,
      "Non-ICU (active)"=nominalBold_shade_0,
      "ICU (inactive)"=nominalMuted_shade_3,
      "ICU (active)"=nominalBold_shade_3
    )
  ) +
  scale_fill_manual(
      # name="March 11, 2021",
      values=c(
        "Non-ICU (inactive)"=nominalMuted_shade_0,
        "Non-ICU (active)"=nominalBold_shade_0,
        "ICU (inactive)"=nominalMuted_shade_3,
        "ICU (active)"=nominalBold_shade_3
      ),
      labels=c(
        paste(comma(final_nonicu_inactive), "Non-ICU (inactive)", sep=" "),
        paste(comma(final_nonicu_active), "Non-ICU (active/contagious)", sep=" "),
        paste(comma(final_icu_inactive), "ICU (inactive)", sep=" "),
        paste(comma(final_icu_active), "ICU (active/contagious)", sep=" ")
    )
  ) +
  guides(colour=FALSE) +
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


