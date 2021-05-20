
p_new_daily_cases_100K <- plot_bar_timeseries_w_avg(
  wfp_daily_totals,
  x_var=date,
  y_var=new_daily_cases_100K,
  avg_var=new_7day_cases_100K,
  colour_var="",
  fill_var="",
  group_var="",
  bar_colour=nominalMuted_shade_0,
  avg_colour=nominalBold_shade_1,
  title_str="New daily cases of COVID-19 per capita in Manitoba",
  subtitle_str="Reported cases per 100,000 people", x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="1 month",
  ymin=0, ymax=50, y_units="",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_new_daily_cases_100K <- p_new_daily_cases_100K +
geom_point(data=wfp_daily_totals %>% filter(date == max(date)),
         aes(x=date, y=new_7day_cases_100K),
         color=nominalBold_shade_1, fill=nominalMuted_shade_1, size=1, alpha=1
) +
geom_text(data=wfp_daily_totals %>% filter(date == max(date)),
          aes(x=date + 3, y=new_7day_cases_100K - 1,
          label=wrap_text(paste("Seven-day moving average ", sep=""), 13)
        ),
          color="#000000", hjust=.05, vjust=-.3, size=3
) +
geom_text(data=wfp_daily_totals %>% filter(date == max(date)),
          aes(x=date + 3, y=new_7day_cases_100K - 1, label=paste(comma(new_7day_cases_100K, accuracy=1), sep="")),
          color="#000000", hjust=.05, vjust=0.8, size=4, fontface="bold"
)


wfp_new_daily_cases_100K <- prepare_plot(p_new_daily_cases_100K)

ggsave_pngpdf(wfp_new_daily_cases_100K, "wfp_new_daily_cases_100K", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
