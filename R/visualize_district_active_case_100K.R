
p_districts_active_cases_100K <- plot_bar_x_reordered_y(
  dashboard_daily_status_districts_all %>% filter(area_name != "Unknown District") %>%  filter(!is.na(district_active_cases_100K) )  %>%  filter(district_active_cases_100K > 0),
  x_var=area_name, y_var=district_active_cases_100K,
  # colour_var=rha, fill_var=rha, group_var=rha,
  title_str="Active cases of COVID-19 per capita in Manitoba health districts",
  subtitle_str="",
  x_str="", y_str="", y_units="", ymin=0, ymax=7500,
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_districts_active_cases_100K <- p_districts_active_cases_100K +
  geom_text(
            aes(x=area_name, y=district_active_cases_100K,
                label=comma(district_active_cases_100K, accuracy=1)
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

wfp_districts_active_cases_100K <- prepare_plot(p_districts_active_cases_100K)
ggsave_pngpdf(wfp_districts_active_cases_100K, "wfp_districts_active_cases_100K", width_var=8.66, height_var=14, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(wfp_districts_active_cases_100K, "wfp_active_case_rate_per_district", width_var=8.66, height_var=14, dpi_var=300, scale_var=1, units_var="in")
