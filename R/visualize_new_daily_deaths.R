
p_new_daily_deaths <- plot_bar_timeseries(
  wfp_daily_totals,
  x_var=date,
  y_var=new_daily_deaths,
  colour_var="",
  fill_var="",
  group_var="",
  bar_colour=wfp_blue,
  title_str="Daily deaths from COVID-19 reported in Manitoba",
  subtitle_str="", x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="1 month",
  ymin=0, ymax=50, y_units="",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_new_daily_deaths <- prepare_plot(p_new_daily_deaths)

ggsave_pngpdf(p_new_daily_deaths, "wfp_new_daily_deaths", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
