
p_covid19_districts_cases_vax_uptake1 <- ggplot(covid19_districts_cases_vax) +
  aes(x = district_total_cases_100K, y = uptake_1) +
  geom_point(size = 2, colour = wfp_blue, fill = wfp_blue, alpha = .2, shape = 21) +
  geom_point(data = covid19_districts_cases_vax %>% filter(uptake_1 <= 55), size = 2, colour = "#ffffff", fill = wfp_blue, alpha = 1, shape = 21) +
  geom_text_repel(
    data = covid19_districts_cases_vax %>% filter(uptake_1 <= 55),
    aes(x = district_total_cases_100K, y = uptake_1, label = area_name),
    color = "#222222",
    size = 3.5,
    hjust = -1,
    # vjust=-.25,
    direction = "y",
    segment.color = "#555555",
    segment.size = .25,
    show.legend = FALSE
  ) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, 30000), labels = comma) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 100), labels = function(x) {
    ifelse(x == 100, paste(x, "%", sep = ""), x)
  }) +
  labs(
    title = wrap_text("Vaccine uptake and total COVID-19 cases per 100,000 by district", 90),
    subtitle = wrap_text("Districts with 55 or fewer percentage of eligible residents vaccinated with a first dose", 90),
    caption = wrap_text(paste(toupper("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH"), " (2021-06-29)", sep = ""), 120), x = "",
    x = "Total cases per 100,000 people",
    y = "Percentage of eligible population with a first dose",
    colour = "",
    fill = ""
  ) +
  minimal_theme() +
  # coord_flip() +
  theme(
    axis.title.x = ggplot2::element_text(face = "bold", size = 10, color = "#222222"),
    axis.text.x = ggplot2::element_text(size = 10, color = "#222222"),
  )


wfp_covid19_districts_cases_vax_uptake1 <- prepare_plot(p_covid19_districts_cases_vax_uptake1)
ggsave_pngpdf(wfp_covid19_districts_cases_vax_uptake1, "wfp_covid19_districts_cases_vax_uptake1", width_var = 8.66, height_var = 6, dpi_var = 150, scale_var = 1, units_var = "in")
