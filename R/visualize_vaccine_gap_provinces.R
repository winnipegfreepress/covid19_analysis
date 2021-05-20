
p_vaccine_gap_provinces <- plot_bar_x_reordered_y_stacked_pct(
  covid_vaccine_unused_compare_tall,
  x_var=province,
  xreorder_var=pct_used,
  y_var=pct,
  colour_var=type,
  fill_var=type,
  group_var="",
  bar_colour=nominalMuted_shade_0,
  title_str="Administered and unused doses of COVID-19 vaccine in Canada",
  subtitle_str="Percentage of all COVID-19 vaccine doses distributed by the federal government. The federal government counts five doses per vial of mNRA vaccine while provinces count six doses, so the percentage of doses administered may equal more than 100.",
  x_str="", y_str="",
  ymin=0, ymax=120, y_units="%",
  source_str="Manitoba Health Vaccine Dashboard", lastupdate_str=last_update_timestamp
)

p_vaccine_gap_provinces <- p_vaccine_gap_provinces +
  geom_text(data=covid_vaccine_unused_compare_tall %>% filter(type=="Administered doses"),
    aes(
      x=reorder(province, pct_used), y=pct - 1,
      label=wrap_text(paste(
        round(pct, 1), "%",
        sep=""), 40
      )
    ),
    hjust=1, vjust=.4, size=3.5, color="#ffffff"
  ) +
  scale_fill_manual(values=c(
    "Administered doses"=wfp_blue,
    "Unused doses"=nominalMuted_shade_0
    ),
    guide=FALSE
  ) +
  guides(colour=FALSE) +
  theme(
    legend.title=element_blank(),
    legend.position="bottom",
    panel.grid.major.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank()

  )


wfp_vaccine_gap_provinces <- prepare_plot(p_vaccine_gap_provinces)
ggsave_pngpdf(wfp_vaccine_gap_provinces, "wfp_vaccine_gap_provinces", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

