
p_covid19_vaccine_demographics_coverage <- plot_bar_nominal(
  COVID19_MB_vaccine_demographics_coverage_df %>% filter(!is.na(pct_vaccinated_fullpop)) %>% filter(pct_vaccinated_fullpop > 0),
  x_var=age_group,
  y_var=pct_vaccinated_fullpop,
  group_var="",
  bar_colour=wfp_blue,
  title_str="Percentage of eligible Manitobans who have received at least one dose of COVID-19 vaccine",
  subtitle_str="Total first dose vaccinations in Manitoba",
  x_str="", y_str="",
  ymin=0, ymax=120, y_units="%",
  source_str="Manitoba Health, Statistics Canada", lastupdate_str=last_update_timestamp
)

p_covid19_vaccine_demographics_coverage <- p_covid19_vaccine_demographics_coverage +
  geom_text(
    aes(
      x=age_group,
      y=pct_vaccinated_fullpop,
      label=paste(format(pct_vaccinated_fullpop, digits=2), "%", sep="")
    ),
    hjust=-.15,
    vjust=-.1,
    fontface="bold",
    size=3.5
  ) +
  geom_text(
    aes(
      x=age_group,
      y=pct_vaccinated_fullpop,
      label=paste(comma(first_dose_total, accuracy=1), " doses", sep="")
    ),
    hjust=-.15,
    vjust=1.5,
    size=2.5,
    colour="#555555"
  ) +
  # annotate("text",
  #          x="50-59",
  #          y=70,
  #          label=wrap_text("55.9 per cent of Manitobans \n80 years of age or older \nhave received at least the first dose of a COVID-19 vaccine", 30),
  #          size=4,
  #          fontface="bold",
  #          colour="#000000"
  # ) +
  coord_flip() +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 120),
    labels=function(x) { ifelse(x %in% c(120), paste(x, "%", sep=""), x) }
  ) +
  labs(
    caption=wrap_text(paste("Calculated percentages may exceed 100% due to differences between actual and projected 2020 populations.", "\n\n",
                              toupper(paste("WINNIPEG FREE PRESS — SOURCE: ",
                                      "Manitoba Health, Statistics Canada", " (", last_update_timestamp, ")",sep="")),

                              sep=""), 120)
  ) +
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


wfp_covid19_vaccine_demographics_coverage <- prepare_plot(p_covid19_vaccine_demographics_coverage)
ggsave_pngpdf(wfp_covid19_vaccine_demographics_coverage, "wfp_covid19_vaccine_demographics_coverage", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")


