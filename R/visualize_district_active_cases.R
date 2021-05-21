
p_districts_active_cases <- plot_bar_x_reordered_y(
  dashboard_daily_status_districts_all %>% filter(area_name != "Unknown District") %>%  filter(!is.na(district_active_cases_100K) )  %>%  filter(active_cases > 0),
  x_var=area_name, y_var=active_cases,
  # colour_var=rha, fill_var=rha, group_var=rha,
  title_str="Active cases of COVID-19 in Manitoba health districts",
  subtitle_str="Due to a backlog in provincial tracking of recovered cases, active cases may be lower than reported.",
  x_str="", y_str="", y_units="", ymin=0, ymax=750,
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_districts_active_cases <- p_districts_active_cases +
  geom_text(
    aes(x=area_name, y=active_cases,
        label=comma(active_cases, accuracy=1)
    ),
    color="#000000", hjust=-.25, vjust=.45, size=4
  ) +
  minimal_theme() +
  theme(
    axis.line=element_blank(),
    axis.text.x=element_blank(),
    # axis.text.y=element_blank(),
    # axis.text.y=ggplot2::element_text(size=9),
    axis.ticks=element_blank(),
    axis.title.x=element_blank(),
    # axis.title.y=element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank(),
    legend.position="none"
  )

wfp_districts_active_cases <- prepare_plot(p_districts_active_cases)
ggsave_pngpdf(wfp_districts_active_cases, "wfp_districts_active_cases", width_var=8.66, height_var=14, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(wfp_districts_active_cases, "wfp_active_cases_per_district", width_var=8.66, height_var=14, dpi_var=300, scale_var=1, units_var="in")
