
COVID19_MB_vaccine_demographics_coverage <- left_join(
  MB_pop_estimates_2020,
  COVID19_MB_vaccine_age_groups,
  by=c("age_group_mb"="age_group")
) %>%
  rename(
    doses_administered_ttd=doses_administered_ttd,
    population_2020est_statcan=sumpop
  ) %>%
  mutate(
    doses_administered_ttd=as.numeric(doses_administered_ttd)
  ) %>%
  filter(age_group_mb != "0-9")


# Split off 90+
COVID19_MB_vaccine_demographics_coverage__90plus <- COVID19_MB_vaccine_demographics_coverage %>%
  filter(age_group_mb %in% c("90-99", "99+")) %>%
  pivot_wider(names_from="dose_type",
              values_from = doses_administered_ttd) %>%
  summarize(
    population_2020est_statcan = sum(population_2020est_statcan),
    first_doses_administered = sum(first_doses_administered),
    second_doses_administered = sum(second_doses_administered),
  ) %>%
  mutate(
    age_group_mb = "90 plus"
  ) %>%
  select(
    age_group_mb,
    population_2020est_statcan,
    first_doses_administered,
    second_doses_administered
  ) %>%
  pivot_longer(
    cols=c(first_doses_administered,
           second_doses_administered),
    names_to="dose_type",
    values_to="doses_administered_ttd"
  )

COVID19_MB_vaccine_demographics_coverage__under90 <- COVID19_MB_vaccine_demographics_coverage %>%
  filter(age_group_mb %notin% c("90-99", "99+"))

COVID19_MB_vaccine_demographics_coverage <-  rbind(
  COVID19_MB_vaccine_demographics_coverage__under90,
  COVID19_MB_vaccine_demographics_coverage__90plus
) %>%
  mutate(
    pct_pop_vaccinated = round(doses_administered_ttd / population_2020est_statcan * 100, digits=1),
    dose_type = ifelse(dose_type == "first_doses_administered", "First dose", "Second dose")
  )



p_covid19_vaccine_demographics_coverage_1st2nd <- plot_bar_nominal(
  COVID19_MB_vaccine_demographics_coverage %>% filter(!is.na(pct_pop_vaccinated)) %>% filter(pct_pop_vaccinated > 0),
  x_var=age_group_mb,
  y_var=pct_pop_vaccinated,
  group_var="",
  bar_colour=wfp_blue,
  title_str="Percentage of eligible Manitobans who have received a first or second dose of a COVID-19 vaccine",
  subtitle_str="Reported COVID-19 vaccinations",
  x_str="", y_str="",
  ymin=0, ymax=120, y_units="%",
  source_str="Manitoba Health, Statistics Canada", lastupdate_str=last_update_timestamp
)

p_covid19_vaccine_demographics_coverage_1st2nd <- p_covid19_vaccine_demographics_coverage_1st2nd +
  geom_text(
    aes(
      x=age_group_mb,
      y=pct_pop_vaccinated,
      label=paste(format(pct_pop_vaccinated, digits=1), "%", sep="")
    ),
    hjust=-.15,
    vjust=-.1,
    fontface="bold",
    size=3.5
  ) +
  geom_text(
    aes(
      x=age_group_mb,
      y=pct_pop_vaccinated,
      label=paste(comma(doses_administered_ttd, accuracy=1), " doses", sep="")
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
    labels=function(x) { ifelse(x %in% c(100), paste(x, "%", sep=""), x) }
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
    strip.background=ggplot2::element_blank(),
    strip.text=ggplot2::element_text(size =13, hjust=0, face="bold"),
    panel.grid.major.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank(),
    panel.border=ggplot2::element_blank()
  ) +
  facet_wrap(.~dose_type)


wfp_covid19_vaccine_demographics_coverage_1st2nd <- prepare_plot(p_covid19_vaccine_demographics_coverage_1st2nd)
ggsave_pngpdf(wfp_covid19_vaccine_demographics_coverage_1st2nd, "wfp_covid19_vaccine_demographics_coverage_1st2nd", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")




