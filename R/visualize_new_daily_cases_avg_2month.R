
p_new_daily_cases_avg_2month <- plot_bar_timeseries_w_avg(
  wfp_daily_totals,
  x_var=date,
  y_var=new_daily_cases,
  avg_var=cases_mavg_7day,
  colour_var="",
  fill_var="",
  group_var="",
  bar_colour=nominalMuted_shade_0,
  avg_colour=nominalBold_shade_1,
  title_str="New daily cases of COVID-19 reported in Manitoba",
  subtitle_str="", x_str="", y_str="",
  xmin="2020-03-01", xmax=xmax_var, xformat="%b", x_units="1 month",
  ymin=0, ymax=800, y_units="",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_new_daily_cases_avg_2month <- p_new_daily_cases_avg_2month +


  geom_rect(data = data.frame(xmin = as.Date("2020-09-21"), xmax = as.Date("2020-11-30"), ymin = 0, ymax = 800),
            mapping = aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
            size = 0L, colour = "black", fill = nominalMuted_shade_1, alpha = 0.5, inherit.aes = FALSE) +
  geom_rect(data = data.frame(xmin = as.Date("2020-11-30"), xmax = as.Date("2021-03-01"), ymin = 0, ymax = 800),
            mapping = aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
            size = 0L, colour = "black", fill = nominalMuted_shade_2, alpha = 0.5, inherit.aes = FALSE) +

  geom_rect(data = data.frame(xmin = as.Date("2021-03-30"), xmax = as.Date("2021-05-23"), ymin = 0, ymax = 800),
            mapping = aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
            size = 0L, colour = "black", fill = nominalMuted_shade_1, alpha = 0.5, inherit.aes = FALSE) +
  geom_rect(data = data.frame(xmin = as.Date("2021-05-23"), xmax = as.Date("2021-07-15"), ymin = 0, ymax = 800),
            mapping = aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
            size = 0L, colour = "black", fill = nominalMuted_shade_2, alpha = 0.5, inherit.aes = FALSE) +

  geom_point(data=wfp_daily_totals %>% filter(date == max(date)),
             aes(x=date, y=cases_mavg_7day),
             color=nominalBold_shade_1, fill=nominalMuted_shade_1, size=1, alpha=1
  ) +
  geom_text(data=wfp_daily_totals %>% filter(date == max(date)),
            aes(x=date + 6, y=cases_mavg_7day - 1,
                label=wrap_text(paste("Seven-day moving average ", sep=""), 13)
            ),
            color="#000000", hjust=.05, vjust=-.3, size=3
  ) +
  geom_text(data=wfp_daily_totals %>% filter(date == max(date)),
            aes(x=date + 6, y=cases_mavg_7day - 1, label=paste(comma(cases_mavg_7day, accuracy=1), sep="")),
            color="#000000", hjust=.05, vjust=0.8, size=4, fontface="bold"
  )

wfp_new_daily_cases_avg_2month <- prepare_plot(p_new_daily_cases_avg_2month)

ggsave_pngpdf(wfp_new_daily_cases_avg_2month, "wfp_new_daily_cases_avg_2month", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
