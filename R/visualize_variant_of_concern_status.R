
p_variants_of_concern_transmission <- ggplot(dashboard_variants_of_concern_transmission) +
  aes(x=variant, y=voc_cases_total, group=variant) +
  geom_bar(stat="identity", colour=wfp_blue, fill=wfp_blue) +
  geom_text(
    aes(x=variant, y=voc_cases_total, group=variant, label=comma(voc_cases_total, accuracy=1)),
    stat="identity", size=4, vjust=-.5) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0,7500),
    labels=scales::comma
  ) +
  labs(
    title=wrap_text("Most likely acquisition type for reported COVID-19 variant of concern cases in Manitoba", 65),
    caption=wrap_text(toupper(paste("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH (", last_update_timestamp, ")", sep="")), 80),
    x="",
    y="",
    fill=""
  ) +
  minimal_theme() +
  theme(
    plot.title=ggplot2::element_text(size=18, margin=ggplot2::margin(0,0,10,0)),
    strip.background=ggplot2::element_blank(),
    strip.text=ggplot2::element_text(size =13, hjust=0, face="bold"),
    panel.border=ggplot2::element_blank()
  ) +
  facet_wrap(~staging)


p_covid19_variants_of_concern_type <- plot_bar_nominal(
  dashboard_variants_of_concern_type,
  x_var=variant,
  y_var=total,
  group_var="",
  bar_colour=wfp_blue,
  title_str="COVID-19 variant of concern cases reported in Manitoba",
  subtitle_str="",
  x_str="", y_str="",
  ymin=0, ymax=10000, y_units="%",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_covid19_variants_of_concern_type <- p_covid19_variants_of_concern_type +
  geom_text(
    aes(
      x=variant,
      y=total,
      label=paste(comma(total, accuracy=1), sep="")
    ),
    vjust=-.7,
    # fontface="bold",
    size=4
  )


wfp_variants_of_concern_transmission <- prepare_plot(p_variants_of_concern_transmission)
ggsave_pngpdf(wfp_variants_of_concern_transmission, "wfp_variants_of_concern_transmission", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

wfp_covid19_variants_of_concern_type <- prepare_plot(p_covid19_variants_of_concern_type)
ggsave_pngpdf(wfp_covid19_variants_of_concern_type, "wfp_covid19_variants", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

