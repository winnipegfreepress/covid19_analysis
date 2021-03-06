
cumulative_total_doses_cnt <- cumulative_first_doses_cnt + cumulative_second_doses_cnt

p_covid_19_mb_vaccinations_first_second <- plot_bar_stack(
  COVID19_MB_first_second_vaccine_dose__tall %>% filter(!is.na(vaccination_date)) %>% filter(type!="remainder_first_doses"),
  x_var=vaccination_date,
  y_var=count,
  colour_var=type,
  fill_var=type,
  group_var="",
  bar_colour=nominalMuted_shade_0,
  title_str="First and second dose vaccinations for COVID-19 in Manitoba",
  subtitle_str="Total vaccinations to date",
  x_str="", y_str="",
  xmin="2020-12-01", xmax=xmax_var, xformat="%b", x_units="1 month",
  ymin=0, ymax=3000000, y_units="",
  source_str="Manitoba Health Vaccine Dashboard", lastupdate_str=last_update_timestamp
)

p_covid_19_mb_vaccinations_first_second <- p_covid_19_mb_vaccinations_first_second +
  # annotate("text",
  #          x=as.Date("2021-03-01"),
  #          y=1570000,
  #          label=wrap_text("March 3: Manitoba begins delaying administration of second doses of vaccine to increase the number of people receiving first doses.", 35),
  #          hjust=-.001, vjust=.7, size=4,
  #          colour="#000000"
  # ) +
  # annotate("segment",
  #          x=as.Date("2021-02-23"),
  #          y=1050000,
  #          xend=as.Date("2021-02-23"),
  #          yend=1000, size=.25,
  #          colour="#9c9c9c"
  # ) +
  scale_colour_manual(
    values=c(
      "cumulative_first_doses"=nominalMuted_shade_0,
      "cumulative_second_doses"=nominalBold_shade_1,
      "remainder_first_doses"=nominalBold_shade_2
    ),
    labels=c(
      paste("First doses", sep=" "),
      paste("Second doses", sep=" ")
    )
  ) +
  scale_fill_manual(
    values=c(
      "cumulative_first_doses"=nominalMuted_shade_0,
      "cumulative_second_doses"=nominalBold_shade_1,
      "remainder_first_doses"=nominalBold_shade_0
    ),
    labels=c(
      paste(comma(cumulative_first_doses_cnt), "first doses", sep=" "),
      paste(comma(cumulative_second_doses_cnt), "second doses", sep=" "),
      paste(comma(cumulative_first_only_doses_cnt), "first dose only", sep=" ")

    )
  ) +
  guides(colour=FALSE,
         fill=guide_legend(paste(comma(cumulative_total_doses_cnt), "doses administered", sep=" "))
  ) +
  theme(
    legend.title=element_text(size=12, face="bold"),
    legend.position=c(.40, 1.0),
    legend.justification=c("right", "top"),
    legend.box.just="right",
    legend.margin=margin(10, 10, 10, 10)
  )

wfp_covid_19_mb_vaccinations_first_second <- prepare_plot(p_covid_19_mb_vaccinations_first_second)

ggsave_pngpdf(wfp_covid_19_mb_vaccinations_first_second, "wfp_covid_19_mb_vaccinations_first_second", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(wfp_covid_19_mb_vaccinations_first_second, "wfp_vaccine_administration_mb", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")


