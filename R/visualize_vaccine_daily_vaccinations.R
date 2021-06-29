
# COMBINED

COVID19_MB_daily_1st_2nd_vaccine_dose_tall <-  COVID19_MB_first_second_vaccine_dose %>%
  select(vaccination_date, first_doses, second_doses, total_doses) %>%
  pivot_longer(
    -vaccination_date,
    names_to="type",
    values_to="count"
  ) %>%
  mutate(
    type=factor(type, levels=c("first_doses", "second_doses", "total_doses"))
  )


most_recent_date_admin_vaccines <- COVID19_MB_daily_1st_2nd_vaccine_dose_tall %>%
  filter(type == "total_doses") %>%
  filter(vaccination_date == max(vaccination_date)) %>%
  select(count) %>% pull()


p_covid_19_mb_daily_vaccinations_1st2nd <- plot_bar_stack(
  COVID19_MB_daily_1st_2nd_vaccine_dose_tall %>% filter(type != "total_doses"),
  x_var=vaccination_date,
  y_var=count,
  colour_var=type,
  fill_var=type,
  group_var="",
  # bar_colour=nominalMuted_shade_0,
  title_str="Daily vaccinations for COVID-19 in Manitoba",
  # subtitle_str="First and second doses",
  x_str="", y_str="",
  xmin="2020-12-01", xmax=xmax_var, xformat="%b", x_units="1 month",
  ymin=0, ymax=25000, y_units="",
  source_str="Manitoba Health Vaccine Dashboard", lastupdate_str=last_update_timestamp
)


p_covid_19_mb_daily_vaccinations_1st2nd <- p_covid_19_mb_daily_vaccinations_1st2nd +
  # annotate("text",
  #          x=as.Date(max(COVID19_MB_daily_1st_2nd_vaccine_dose_tall$vaccination_date)) + 2,
  #          y=most_recent_date_admin_vaccines,
  #          label=paste(comma(most_recent_date_admin_vaccines, accuracy=1), " doses\nadministered", sep=""),
  #          size=4,
  #          hjust=0
  # ) +
  # annotate("rect",
  #          xmin=as.Date("2021-03-29"), xmax=as.Date("2021-05-30"),
  #          ymin=6000, ymax=7000,
  #          linetype="dashed",
  #          colour=NA,
  #          fill=nominalBold_shade_1,
  #          alpha=.5
  # ) +
  # annotate("text",
  #          x=as.Date("2021-03-29"),
  #          y=6700,
  #          label=paste("March 29 target", sep=""),
  #          fontface="bold",
  #          size=4,
  #          hjust=-.03,
  #          vjust=.4
  # ) +
  # annotate("text",
  #          x=as.Date("2021-03-29"),
  #          y=6300,
  #          label=paste("6-7,000 daily vaccine doses", sep=""),
  #          size=3.5,
  #          hjust=-.03,
  # ) +
  scale_colour_manual(values=c(
      "first_doses"=nominalMuted_shade_0,
      "second_doses"=nominalBold_shade_1
    )
  ) +
  scale_fill_manual(
    # name="March 11, 2021",
    values=c(
      "first_doses"=nominalMuted_shade_0,
      "second_doses"=nominalBold_shade_1
    ),
    labels=c(
      "First dose",
      "Second dose"
    )
  ) +
  guides(colour=FALSE) +
  theme(
    legend.title=ggplot2::element_text(face="bold"),
    legend.position=c(.25, 1),
    legend.justification=c("right", "top"),
    legend.box.just="right",
    legend.margin=margin(10, 10, 10, 10)
  )



p_covid_19_mb_daily_vaccinations_combined <- plot_bar_timeseries(
  COVID19_MB_daily_1st_2nd_vaccine_dose_tall %>% filter(type == "total_doses"),
  x_var=vaccination_date,
  y_var=count,
  group_var="",
  bar_colour=wfp_blue,
  title_str="Daily COVID-19 vaccine doses administered in Manitoba",
  subtitle_str="Combined daily total of first and second doses",
  x_str="", y_str="",
  xmin="2020-12-01", xmax="2021-08-30", xformat="%b", x_units="1 month",
  ymin=0, ymax=40000, y_units="",
  source_str="Manitoba Health Vaccine Dashboard", lastupdate_str=last_update_timestamp
)


# p_covid_19_mb_daily_vaccinations_combined <- p_covid_19_mb_daily_vaccinations_combined +
  # annotate("text",
  #        x=as.Date(max(COVID19_MB_daily_1st_2nd_vaccine_dose_tall$vaccination_date)) + 2,
  #        y=most_recent_date_admin_vaccines,
  #        label=paste(comma(most_recent_date_admin_vaccines, accuracy=1), " doses\nadministered", sep=""),
  #        size=4,
  #        hjust=0
  # ) +
  # annotate("rect",
  #          xmin=as.Date("2021-03-29"), xmax=as.Date("2021-05-30"),
  #          ymin=6000, ymax=7000,
  #          linetype="dashed",
  #          colour=NA,
  #          fill=nominalBold_shade_1,
  #          alpha=.5
  #         ) +
  # annotate("text",
  #          x=as.Date("2021-03-29"),
  #          y=6700,
  #          label=paste("March 29 target", sep=""),
  #          fontface="bold",
  #          size=4,
  #          hjust=-.03,
  #          vjust=.4
  # ) +
  # annotate("text",
  #          x=as.Date("2021-03-29"),
  #          y=6300,
  #          label=paste("6-7,000 daily vaccine doses", sep=""),
  #          size=3.5,
  #          hjust=-.03,
  # )

wfp_covid_19_mb_daily_vaccinations_1st2nd <- prepare_plot(p_covid_19_mb_daily_vaccinations_1st2nd)
ggsave_pngpdf(wfp_covid_19_mb_daily_vaccinations_1st2nd, "wfp_covid_19_mb_daily_vaccinations_1st2nd", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")


wfp_covid_19_mb_daily_vaccinations_combined <- prepare_plot(p_covid_19_mb_daily_vaccinations_combined)
ggsave_pngpdf(wfp_covid_19_mb_daily_vaccinations_combined, "wfp_covid_19_mb_daily_vaccinations_combined", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
