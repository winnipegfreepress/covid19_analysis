
p_rha_total_cases_100K <- plot_line_timeseries(
  dashboard_daily_status_manitoba,
  x_var=date,
  y_var=cumulative_cases_100K,
  group_var=rha,
  line_colour=nominalMuted_shade_0,
  title_str="Reported cases of COVID-19 per capita in Manitoba",
  subtitle_str="",
  x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="3 months",
  ymin=0, ymax=10000, y_units="%",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_rha_total_cases_100K <- p_rha_total_cases_100K +
geom_point(data=dashboard_daily_status_manitoba %>% filter(date == max(date)),
         aes(x=date, y=cumulative_cases_100K),
         color=nominalBold_shade_0, fill=nominalMuted_shade_1, size=1.5, alpha=1
) +
geom_text(data=dashboard_daily_status_manitoba %>% filter(date == max(date)),
          aes(x=as.Date(xmin_var) + 1, y=9000,
            label=paste(
              comma(cumulative_cases_100K, accuracy=1), "/100K people", "\n",
              sep="")
          ),
          color="#000000", hjust=-.02, vjust=.8, size=3.5
) +
theme(
  strip.background=ggplot2::element_blank(),
  strip.text=ggplot2::element_text(size =13, hjust=0, face="bold"),
  panel.border=ggplot2::element_blank()
) +
facet_wrap(.~rha)

wfp_rha_total_cases_100K <- prepare_plot(p_rha_total_cases_100K)
ggsave_pngpdf(wfp_rha_total_cases_100K, "wfp_rha_total_cases_100K", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
