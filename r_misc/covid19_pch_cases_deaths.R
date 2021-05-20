COVID_19_PCH_Totals_20210309 <- read_excel("data/raw/COVID_19_PCH_Totals_20210309.xlsx", skip = 4) %>%
  clean_names()

# Total row was manually confirmed as accurate
COVID_19_PCH_Totals_20210309_totals <- COVID_19_PCH_Totals_20210309 %>%
  filter(category == "Total")


COVID_19_PCH_Totals_20210309_status_tall <- COVID_19_PCH_Totals_20210309 %>%
  filter(category != "Total") %>%
  select(
    -category,
    -staff,
    -non_staff,
    -total
  ) %>%
  pivot_longer(
    -location,
    names_to="status",
    values_to="cnt"
  ) %>%
  left_join(
    COVID_19_PCH_Totals_20210309,
    by=c("location" = "location")
  ) %>%
  select(
    -category,
    -staff,
    -non_staff,
    -active,
    -recovered,
    -deaths
  ) %>%
  mutate(
    status = factor(status, levels=c("deaths", "recovered", "active"))
  )

# View(COVID_19_PCH_Totals_20210309_status_tall)

p_covid19_pch_case_status <- plot_bar_x_reordered_y_stacked_pct(
  COVID_19_PCH_Totals_20210309_status_tall,
  x_var=location,
  xreorder_var=total,
  y_var=cnt,
  colour_var=status,
  fill_var=status,
  group_var="",
  title_str="COVID-19 cases in Manitoba's long term care facilities",
  subtitle_str=paste(
    comma(COVID_19_PCH_Totals_20210309_totals$staff), " cases among staff and ", comma(COVID_19_PCH_Totals_20210309_totals$non_staff), " cases among residents",
    sep=""
  ),
  x_str="", y_str="",
  ymin=0, ymax=300, y_units="",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)


p_covid19_pch_case_status <- p_covid19_pch_case_status +
  geom_text(aes(
              x = reorder(location, total), y = total,
              label = paste(comma(total, accuracy=1), sep="")
            ), color="#000000", hjust = -.3, vjust = .5, size=4
  ) +


  geom_text(aes(
    x = "Carberry PCH", y = 50,
    label = "Outbreak announced ~ Oct. 2"
    ), color="#000000", vjust = .5, size=3.5
  ) +

  geom_text(aes(
    x = "Donwood Manor", y = 50,
    label = "Outbreak announced ~ Sept. 6"
  ), color="#000000", vjust = .5, size=3.5
  ) +

  geom_text(aes(
    x = "Pembina Manitou Health Centre and PCH", y = 50,
    label = "Outbreak announced ~ Jan. 22"
  ), color="#000000", vjust = .5, size=3.5
  ) +

  geom_text(aes(
    x = "Rosewood Lodge PCH", y = 50,
    label = "Outbreak announced ~ Dec. 2"
  ), color="#000000", vjust = .5, size=3.5
  ) +

  geom_text(aes(
    x = "Swan Valley Lodge PCH", y = 50,
    label = "Outbreak announced ~ Oct. 25"
  ), color="#000000", vjust = .5, size=3.5
  ) +



  scale_colour_manual(values = c(
    "deaths" = nominalMuted_shade_1,
    "recovered" = nominalMuted_shade_2,
    "active" = nominalMuted_shade_0
  )
  ) +
  scale_fill_manual(
    name=paste(comma(COVID_19_PCH_Totals_20210309_totals$total), " cases", sep=""),
    values = c(
      "deaths" = nominalMuted_shade_1,
      "recovered" = nominalMuted_shade_2,
      "active" = nominalMuted_shade_0
    ),
    labels=c(
      paste(comma(COVID_19_PCH_Totals_20210309_totals$deaths), "deaths", sep=" "),
      paste(comma(COVID_19_PCH_Totals_20210309_totals$recovered), "recovered", sep=" "),
      paste(comma(COVID_19_PCH_Totals_20210309_totals$active), "active", sep=" ")
    )
  ) +
  guides(colour=FALSE) +
  theme(
    legend.title = ggplot2::element_text(face="bold"),
    legend.position = c(.8, .4),
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.margin = margin(10, 10, 10, 10),
    panel.grid.major.y = ggplot2::element_blank(), #ggplot2::element_line(color="#ebebeb"),
    panel.grid.major.x = ggplot2::element_blank(),
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank()
  )


wfp_covid19_pch_case_status <- prepare_plot(p_covid19_pch_case_status)

ggsave_pngpdf(wfp_covid19_pch_case_status, "wfp_covid19_pch_case_status", width_var=8.66, height_var=14, dpi_var=96, scale_var=1, units_var="in")

