
p_mb_deaths <- plot_bar_timeseries(
  wfp_daily_totals,
  x_var=date,
  y_var=deaths,
  colour_var="",
  fill_var="",
  group_var="",
  bar_colour=wfp_blue,
  title_str="COVID-19 deaths reported in Manitoba",
  subtitle_str="", x_str="", y_str="",
  xmin="2020-03-01", xmax=xmax_var, xformat="%b", x_units="1 month",
  ymin=0, ymax=2000, y_units="",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_mb_deaths <- p_mb_deaths +
  # geom_point(data=wfp_daily_totals_last_date,
  #            stat="identity",
  #            aes(x=date, y=deaths),
  #            color="#ffffff",
  #            fill=wfp_blue,
  #            shape=21,
  #            size=2.5
  # ) +
  annotate("text",
           x=wfp_daily_totals_last_date$date + 1,
           y=wfp_daily_totals_last_date$deaths,
           label=wrap_text(comma(wfp_daily_totals_last_date$deaths), 18),
           hjust=-.25, vjust=0.1, size=4,
           colour="#000000", fontface="bold"
  )

wfp_mb_deaths <- prepare_plot(p_mb_deaths)

ggsave_pngpdf(wfp_mb_deaths, "wfp_mb_deaths", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(wfp_mb_deaths, "wfp_mb_deaths_sq", width_var=8.66, height_var=8.66, dpi_var=300, scale_var=1, units_var="in")
