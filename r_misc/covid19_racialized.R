
covid_mb_racial <- read_csv("data/raw/covid_mb_racial.csv") %>%
  clean_names() %>%
  pivot_longer(
    -vismin
  ) %>%
  mutate(
    name=factor(name, levels=c("pct_population", "pct_covid19_cases_may1_dec31"))
  )

# View(covid_mb_racial)

p_covid_racial <- plot_bar_dodge(
  covid_mb_racial,
  x_var=vismin,
  y_var=value,
  colour_var=name,
  fill_var=name,
  group_var=name,
  bar_colour = nominalMuted_shade_0,
  title_str="Percentage of population and share of COVID-19 cases by race and ethnicity in Manitoba",
  subtitle_str="Sample of 15,848 cases reported between May 1-Dec. 31, 2020",
  x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="1 month",
  ymin=0, ymax=100, y_units="%",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_covid_racial <- p_covid_racial +
  # geom_text(
  #   data=covid_mb_racial,
  #   aes(
  #     x_var=vismin,
  #     y_var=value,
  #     label=paste(value, "%", sep="")
  #   ),
  #   # stat = "identity", position="dodge",
  #   color="#222222",
  #   size=3.5,
  #   hjust=-.25,
  #   vjust=-0.25
  #
  # ) +
  scale_y_continuous(
    expand = c(0, 0),
    limits = c(0, 100),
    labels = function(x) {
      ifelse(x == 100, paste(x, "%", sep = ""), x)
    }
  ) +
  coord_flip() +
  scale_colour_manual(values = c(
    "pct_population" = nominalMuted_shade_1,
    "pct_covid19_cases_may1_dec31" = nominalBold_shade_0
  )
  ) +
  scale_fill_manual(values = c(
    "pct_population" = nominalMuted_shade_1,
    "pct_covid19_cases_may1_dec31" = nominalBold_shade_0
  ),
  labels=c(
    paste("Percentage of population", sep=" "),
    paste("Percentage of COVID-19 cases", sep=" ")
  )
  ) +
  guides(colour=FALSE) +
  theme(
    legend.position="bottom"
# #     legend.position = c(.40, 1.0),
#     # legend.justification = c("right", "top"),
# #     legend.box.just = "right",
# #     legend.margin = margin(10, 10, 10, 10)
  )



wfp_covid_racial <- prepare_plot(p_covid_racial)
ggsave_pngpdf(wfp_covid_racial, "wfp_covid_racial", width_var=8.66, height_var=6, dpi_var=96, scale_var=1, units_var="in")
