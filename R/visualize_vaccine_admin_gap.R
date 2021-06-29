

covid_vaccine_dist_admin_last_date <- covid_vaccine_diff_mb_tall %>%
  filter(date == max(date))

total_doses_administered=covid_vaccine_dist_admin_last_date %>% filter(type=="Administered doses") %>%  pull()
total_doses_unused=covid_vaccine_dist_admin_last_date %>% filter(type=="Unused doses") %>%  pull()
total_doses_distributed=total_doses_administered + total_doses_unused

pct_doses_administered <- round(total_doses_administered / total_doses_distributed * 100, digits=2)


p_vaccine_gap <- plot_bar_stack(
  covid_vaccine_diff_mb_tall,
  x_var=date,
  y_var=count,
  colour_var=type,
  fill_var=type,
  group_var="",
  bar_colour=nominalMuted_shade_0,
  title_str="Administered and unused doses of COVID-19 vaccine in Manitoba",
  subtitle_str=paste("Administered ", comma(total_doses_administered), " of ",  comma(total_doses_distributed), " doses distributed by the federal government", sep=""),
  x_str="", y_str="",
  xmin="2020-12-01", xmax=xmax_var, xformat="%b", x_units="1 month",
  ymin=0, ymax=2000000, y_units="",
  source_str="Manitoba Health Vaccine Dashboard", lastupdate_str=last_update_timestamp
)


p_vaccine_gap <- p_vaccine_gap +

    # annotate("text",
    #          x=as.Date("2021-03-04"),
    #          y=180000,
    #          label=wrap_text("March 3: Manitoba begins delaying the timing of second doses of COVID-19 vaccines to increase the number of people receiving the first vaccine", 33),
    #          hjust=1, vjust=0.8, size=4,
    #          colour="#000000"
    # ) +
    # annotate("segment",
    #          x=as.Date("2021-03-03"),
    #          y=130000,
    #          xend=as.Date("2021-03-03"),
    #          yend=1000, size=.5,
    #          colour="#000000"
    # ) +
    annotate("text",
             x=max(covid_vaccine_diff_mb_tall$date) + 5, y=total_doses_administered,
             label=wrap_text(paste(pct_doses_administered, "% of available vaccine doses have been administered", sep=""), 21),
             hjust=0, vjust=1, size=4,
             colour="#000000"
    ) +
    scale_colour_manual(values=c(
      "Administered doses"=wfp_blue,
      "Unused doses"=nominalMuted_shade_1
    )
    ) +
    scale_fill_manual(values=c(
        "Administered doses"=wfp_blue,
        "Unused doses"=nominalMuted_shade_1
        )
    ) +
    guides(colour=FALSE) +
  theme(
    legend.title=ggplot2::element_text(face="bold"),
    legend.position=c(.3, 1),
    legend.justification=c("right", "top"),
    legend.box.just="right",
    legend.margin=margin(10, 10, 10, 10)
  )


wfp_vaccine_gap <- prepare_plot(p_vaccine_gap)
ggsave_pngpdf(wfp_vaccine_gap, "wfp_vaccine_gap", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

