
covid19_school_absent <- read_csv("data/raw/covid19_school_absent.csv") %>%
  clean_names() %>%
  rename(
    school_group = group
  ) %>%
  pivot_longer(
    -c("board", "school_group")
  ) %>%
  mutate(
    school_group = factor(school_group, levels=c("Teachers", "Admin", "EAs"))
  )

# View(covid19_school_absent)


p_covid19_school_absent <- ggplot(covid19_school_absent) +
  aes(x = school_group, y=value, fill = factor(name), colour=factor(name)) +
  geom_bar(stat="identity", position = "dodge") +
  scale_y_continuous(
    expand = c(0, 0),
    limits = c(0, 15000),
    labels = scales::comma
  ) +
  scale_colour_manual(values = c(
    "stats_2019" = nominalMuted_shade_1,
    "stats_2020" = nominalBold_shade_0
    )
  ) +
  scale_fill_manual(values = c(
    "stats_2019" = nominalMuted_shade_1,
    "stats_2020" = nominalBold_shade_0
    ),
    labels=c(
      "2019",
      "2020"
    )
  ) +
  labs(
    title = wrap_text("School sick days", 70),
    # subtitle = wrap_text(subtitle_str, 80),
    caption = wrap_text(paste("Positions reported in units of sick hours have been converted to sick days for ease of comparison.", "\n\n", toupper("WINNIPEG FREE PRESS — SOURCE: SCHOOL BOARDS"), sep=""), 100),
    x = "",
    y = "Reported sick days",
    fill=""
  ) +
  guides(colour=FALSE) +
  minimal_theme() +
  theme(
    legend.position="bottom",
    strip.background = ggplot2::element_blank(),
    strip.text = ggplot2::element_text(size  = 13, hjust = 0, face="bold"),
    panel.border = ggplot2::element_blank()
  ) +
  facet_wrap(vars(board))


wfp_covid19_school_absent <- prepare_plot(p_covid19_school_absent)

ggsave_pngpdf(wfp_covid19_school_absent, "wfp_covid19_school_absent", width_var=8.66, height_var=6, dpi_var=96, scale_var=1, units_var="in")
