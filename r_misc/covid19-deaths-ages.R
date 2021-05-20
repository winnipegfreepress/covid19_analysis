
covid19_deaths_ages <- read_csv("data/raw/covid19-deaths-ages.csv") %>%
  pivot_longer(
    -gender,
    names_to="age",
    values_to="cnt"
  ) %>%
  mutate(
    age = factor(age, levels=c(

      "20s", "30s", "40s",  "50s", "60s","70s",  "80s",  "90s","100s"
    ))
  )

# View(covid19_deaths_ages)

p_covid19_deaths_ages <- ggplot(covid19_deaths_ages) +
  aes(x = age, y = cnt) +
  geom_bar(stat="identity", fill=wfp_blue) +
  geom_text(
    aes(x = age, y=cnt, label=cnt),
    size=4, vjust=-.2, colour="#000000"
  ) +
  scale_fill_manual(values = c(
      "Male" = nominalMuted_shade_0,
      "Female" = nominalBold_shade_1
    ),
    labels=c(
      "Male",
      "Female"
    )
  ) +
  labs(
    title = wrap_text("Reported COVID-19 deaths by age and gender", 70),
    subtitle = "",
    caption = wrap_text(paste(toupper("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH"), sep=""), 120),    x = "",
    y = "",
    colour = "",
    fill=""
  ) +
  minimal_theme() +
  facet_wrap(.~gender) +
  theme(
    strip.background = ggplot2::element_blank(),
    strip.text = ggplot2::element_text(size  = 13, hjust = 0, face="bold"),
    panel.border = ggplot2::element_blank()
  )


wfp_covid19_deaths_ages <- prepare_plot(p_covid19_deaths_ages)

ggsave_pngpdf(wfp_covid19_deaths_ages, "wfp_covid19_deaths_ages", width_var=8.66, height_var=6, dpi_var=96, scale_var=1, units_var="in")
