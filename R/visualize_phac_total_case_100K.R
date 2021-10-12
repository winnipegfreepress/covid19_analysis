
p_phac_total_cases_100K <- plot_bar_x_reordered_y(
  phac_daily %>% filter(prname != "Canada") %>% filter(prname != "Repatriated travellers") %>% filter(date == max(date)),
  x_var=prname, y_var=total_reported_100K,
  bar_colour=nominalMuted_shade_0,
  # colour_var=rha, fill_var=rha, group_var=rha,
  title_str="COVID-19 cases per capita in Canada",
  subtitle_str="All cases reported per 100,000 people", x_str="", y_str="",
  y_units="", ymin=0, ymax=8000,
  source_str="Public Health Agency of Canada", lastupdate_str=last_update_timestamp
)

p_phac_total_cases_100K <- p_phac_total_cases_100K +
  geom_col(
      data=phac_daily %>% filter(prname != "Canada") %>% filter(prname == "Manitoba") %>% filter(date == max(date)),
      aes(x=reorder(prname, total_reported_100K), y=total_reported_100K),
      colour=wfp_blue, fill=wfp_blue, size=.05
    ) +
  geom_text(
            aes(x=prname, y=total_reported_100K,
                label=comma(total_reported_100K, accuracy=1)
            ),
            color="#000000", hjust=-.25, vjust=.25, size=4
  ) +
  minimal_theme() +
  theme(
    axis.line=element_blank(),
    axis.text.x=element_blank(),
    axis.ticks=element_blank(),
    axis.title.x=element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank(),
    legend.position="none"
  )

wfp_phac_total_cases_100K <- prepare_plot(p_phac_total_cases_100K)
ggsave_pngpdf(wfp_phac_total_cases_100K, "wfp_phac_total_cases_100K", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(wfp_phac_total_cases_100K, "wfp-covid-19-cases-per-capita-web", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
