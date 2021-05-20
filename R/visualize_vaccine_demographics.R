
p_covid19_vaccine_demographics <- plot_bar_stack_nominal(
  COVID19_MB_vaccine_demographics_bothgenders_tall,
  x_var=age_group,
  y_var=doses_administered_ttd,
  # xreorder_var=doses_administered_ttd,
  colour_var=dose_type,
  fill_var=dose_type,
  group_var="",
  bar_colour=nominalMuted_shade_0,
  title_str="Age groups of Manitobans vaccinated against COVID-19",
  subtitle_str="Total vaccinations to date",
  x_str="", y_str="",
  ymin=0, ymax=30000, y_units="",
  source_str="Manitoba Health Vaccine Dashboard", lastupdate_str=last_update_timestamp
)

p_covid19_vaccine_demographics <-  p_covid19_vaccine_demographics +
  # geom_text(data=COVID19_MB_vaccine_demographics,
  #   aes(x=age_group, y=total_doses_administered, label=paste(comma(first_doses_administered), " first doses and ", comma(second_doses_administered), sep=""))
  # ) +
  scale_color_manual(
    values=c(
      "first_doses_administered"=nominalMuted_shade_0,
      "second_doses_administered"=nominalBold_shade_0
    )
  ) +
  scale_fill_manual(
    values=c(
      "first_doses_administered"=nominalMuted_shade_0,
      "second_doses_administered"=nominalBold_shade_0
    ),
    labels=c(
      paste(comma(all_first_doses_administered_cnt), "first doses", sep=" "),
      paste(comma(all_second_doses_administered_cnt), "second doses", sep=" ")
    )
  ) +
  coord_flip() +
  guides(colour=FALSE) +
  theme(
    legend.position=c(.9, 1),
    legend.justification=c("right", "top"),
    legend.box.just="right",
    legend.margin=margin(10, 10, 10, 10),
    panel.grid.major.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank()
    # axis.ticks.y=element_blank()
  )


wfp_covid19_vaccine_demographics <- prepare_plot(p_covid19_vaccine_demographics)

ggsave_pngpdf(wfp_covid19_vaccine_demographics, "wfp_covid19_vaccine_demographics", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(wfp_covid19_vaccine_demographics, "wfp_covid_19_mb_vaccine_demographics_both_genders", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

