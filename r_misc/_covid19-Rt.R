
WFP_COVID19_Rt <- read_csv("data/raw/WFP-COVID19-Rt.csv") %>%
    clean_names() %>%
  pivot_longer(
    -date,
    names_to="location",
    values_to="Rt"
  )

str(WFP_COVID19_Rt)
View(WFP_COVID19_Rt)

#
# p_WFP_COVID19_Rt <- plot_line_timeseries(
#   WFP_COVID19_Rt %>% filter(location=="Manitoba"),
#   x_var=date,
#   y_var=Rt,
#   colour_var=location,
#   fill_var="",
#   group_var="",
#   line_colour = nominalMuted_shade_0,
#   title_str="Effective reproductive number for COVID-19 in Manitoba",
#   subtitle_str="",
#   x_str="", y_str="",
#   xmin="2021-03-01", xmax="2021-03-31", xformat="%b", x_units="1 month",
#   ymin=0, ymax=2, y_units="",
#   source_str="Ryan Imgrund", lastupdate_str=last_update_timestamp
# )


p_WFP_COVID19_Rt <- ggplot(WFP_COVID19_Rt) +
  aes(x = date, y = Rt, colour = location) +
  geom_line(size = 1L) +
  scale_colour_manual(values = c(
    "manitoba" = nominalMuted_shade_0,
    "winnipeg" = nominalBold_shade_1
    ),
    labels=c("Manitoba", "Winnipeg")
  ) +
  minimal_theme() +
  labs(
    title = wrap_text("Reported COVID-19 deaths by age and gender", 70),
    subtitle = "",
    caption = wrap_text(paste(toupper("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH"), sep=""), 120),    x = "",
    y = "",
    colour = "",
    fill=""
  ) +
  minimal_theme() +
  theme(
    strip.background = ggplot2::element_blank(),
    strip.text = ggplot2::element_text(size  = 13, hjust = 0, face="bold"),
    panel.border = ggplot2::element_blank()
  )


wfp_WFP_COVID19_Rt <- prepare_plot(p_WFP_COVID19_Rt)

ggsave_pngpdf(wfp_WFP_COVID19_Rt, "wfp_WFP_COVID19_Rt", width_var=8.66, height_var=6, dpi_var=96, scale_var=1, units_var="in")

