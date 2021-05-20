
WGP_COVID19_death_demographics_20210312 <- read_csv("data/raw/WGP - COVID19 death demographics-20210312.csv")

WGP_COVID19_death_demographics_20210312_totals <- WGP_COVID19_death_demographics_20210312 %>%
  filter(gender == "Total") %>%
  pivot_longer(
    -gender,
    names_to = "age_group",
    values_to="cnt"
  )


WGP_COVID19_death_demographics_20210312_tall <-  WGP_COVID19_death_demographics_20210312 %>%
  filter(gender != "Total") %>%
  pivot_longer(
    -gender,
    names_to = "age_group",
    values_to="cnt"
  ) %>%
  mutate(
    gender = factor(gender, levels=c("Female", "Male")),
    age_group = factor(age_group, levels=c(
      "10s",
      "20s",
      "30s",
      "40s",
      "50s",
      "60s",
      "70s",
      "80s",
      "90s",
      "100s")
      )
  ) %>%
  left_join(
    WGP_COVID19_death_demographics_20210312_totals,
    by=c("age_group" = "age_group")

  ) %>%
  rename(
    cnt = cnt.x,
    age_group_total = cnt.y
  ) %>%
  select(
    -gender.y
  )


# View(WGP_COVID19_death_demographics_20210312)
str(WGP_COVID19_death_demographics_20210312)
View(WGP_COVID19_death_demographics_20210312_tall)

p_covid19_death_demographics <- plot_bar_stack_nominal(
  WGP_COVID19_death_demographics_20210312_tall,
  x_var=age_group,
  y_var=cnt,
  colour_var=gender,
  fill_var=gender,
  group_var="",
  bar_colour = nominalMuted_shade_0,
  title_str="Demographics of Manitoba's reported COVID-19 deaths",
  subtitle_str="Number of deaths", x_str="", y_str="",
  # xmin=xmin_var, xmax="2021-03-15", xformat="%b", x_units="1 month",
  ymin=0, ymax=400, y_units="",
  source_str="Manitoba Health COVID-19 Bulletin", lastupdate_str=last_update_timestamp
)

p_covid19_death_demographics <- p_covid19_death_demographics +
  geom_text(
    data=WGP_COVID19_death_demographics_20210312_totals,
    aes(
      x = age_group, y = cnt,
      label = paste(comma(cnt, accuracy=1), sep="")
  ), color="#000000", hjust = -.3, vjust = .5, size=4
  ) +
  scale_colour_manual(
    values = c(
      "Female"  =  nominalMuted_shade_0,
      "Male"  =  nominalMuted_shade_1
    ),
    guide=FALSE
  ) +
  scale_fill_manual(
    values = c(
      "Female"  =  nominalMuted_shade_0,
      "Male"  =  nominalMuted_shade_1
    )
  ) +
  theme(
    legend.title = ggplot2::element_text(face="bold"),
    legend.position = c(.2, 1),
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.margin = margin(10, 10, 10, 10)
  )

p_covid19_death_demographics <- prepare_plot(p_covid19_death_demographics)
ggsave_pngpdf(p_covid19_death_demographics, "p_covid19_death_demographics", width_var=8.66, height_var=6, dpi_var=96, scale_var=1, units_var="in")
