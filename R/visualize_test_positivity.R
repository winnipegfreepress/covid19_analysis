dashboard_5day_positivity <- dashboard_5day_positivity %>%
  fill(positivity_rate_5day_ywg)


p_5day_test_positivity <- plot_line_timeseries_pct(
  dashboard_5day_positivity,
  x_var=date,
  y_var=positivity_rate_5day_mb,
  colour_var="",
  fill_var="",
  group_var="",
  line_colour=nominalMuted_shade_0,
  title_str="Five-day positivity rate for COVID-19 in Manitoba",
  subtitle_str="The World Health Organization (WHO) advised governments that test positivity rates should be 5 per cent or lower for at least 14 days before reopening",
  x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="1 month",
  ymin=0, ymax=25, y_units="%",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_5day_test_positivity <- p_5day_test_positivity +
geom_point(data=dashboard_5day_positivity %>% filter(date == max(date)),
         aes(x=date, y=positivity_rate_5day_mb),
         color=nominalBold_shade_0, fill=nominalMuted_shade_1, size=1.5, alpha=1
) +
geom_text(data=dashboard_5day_positivity %>% filter(date == max(date)),
          aes(x=date + 5, y=positivity_rate_5day_mb, label=paste("Manitoba ", positivity_rate_5day_mb, "%", sep="")),
          color="#000000", hjust=.05, vjust=-.5, size=4
) +
geom_line(data=dashboard_5day_positivity,
         aes(x=date, y=positivity_rate_5day_ywg),
         color=nominalBold_shade_1, fill=nominalMuted_shade_1, size=1, alpha=1
) +
geom_point(data=dashboard_5day_positivity %>% filter(date == max(date)),
         aes(x=date, y=positivity_rate_5day_ywg),
         color=nominalBold_shade_1, fill=nominalMuted_shade_1, size=1.5, alpha=1
) +
geom_text(data=dashboard_5day_positivity %>% filter(date == max(date)),
          aes(x=date + 5, y=positivity_rate_5day_ywg, label=paste("Winnipeg ", positivity_rate_5day_ywg, "%", sep="")),
          color="#000000", hjust=.05, vjust=.75, size=4
)


wfp_5day_test_positivity <- prepare_plot(p_5day_test_positivity)

ggsave_pngpdf(wfp_5day_test_positivity, "wfp_5day_test_positivity", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(wfp_5day_test_positivity, "wfp_test_positivity", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
