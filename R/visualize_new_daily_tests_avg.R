
p_new_daily_tests_avg <- plot_bar_timeseries_w_avg(
  wfp_daily_totals,
  x_var=date,
  y_var=new_daily_tests,
  avg_var=tests_mavg_7day,
  colour_var="",
  fill_var="",
  group_var="",
  bar_colour=nominalMuted_shade_0,
  avg_colour=nominalBold_shade_1,
  title_str="Daily tests for COVID-19 reported in Manitoba",
  subtitle_str="", x_str="", y_str="",
  xmin="2020-03-01", xmax=xmax_var, xformat="%b", x_units="1 month",
  ymin=0, ymax=7500, y_units="",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_new_daily_tests_avg <- p_new_daily_tests_avg +
geom_point(data=wfp_daily_totals %>% filter(date == max(date)),
         aes(x=date, y=tests_mavg_7day),
         color=nominalBold_shade_1, fill=nominalMuted_shade_1, size=1, alpha=1
) +
geom_text(data=wfp_daily_totals %>% filter(date == max(date)),
          aes(x=date + 3, y=tests_mavg_7day - 1,
          label=wrap_text(paste("Seven-day moving average ", sep=""), 13)
        ),
          color="#000000", hjust=.05, vjust=-.3, size=3
) +
geom_text(data=wfp_daily_totals %>% filter(date == max(date)),
          aes(x=date + 3, y=tests_mavg_7day - 1, label=paste(comma(tests_mavg_7day, accuracy=1), sep="")),
          color="#000000", hjust=.05, vjust=0.8, size=4, fontface="bold"
)


wfp_new_daily_tests_avg <- prepare_plot(p_new_daily_tests_avg)

ggsave_pngpdf(wfp_new_daily_tests_avg, "wfp_new_daily_tests_avg", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(wfp_new_daily_tests_avg, "wfp_tests_daily_7day_mav", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
