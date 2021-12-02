
p_rha_active_cases <- plot_line_timeseries(
  dashboard_daily_status_manitoba,
  x_var=date,
  y_var=active_cases,
  group_var=rha,
  line_colour=nominalMuted_shade_0,
  title_str="Active cases of COVID-19 in Manitoba's regional health authorities",
  subtitle_str="Due to a backlog in provincial tracking of recovered cases, active cases may be lower than reported.",
  x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="3 months",
  ymin=0, ymax=10000, y_units="%",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_rha_active_cases <- p_rha_active_cases +
geom_point(data=dashboard_daily_status_manitoba %>% filter(date == max(date)),
         aes(x=date, y=active_cases),
         color=nominalBold_shade_0, fill=nominalMuted_shade_1, size=1.5, alpha=1
) +
geom_text(data=dashboard_daily_status_manitoba %>% filter(date == max(date)),
          aes(x=as.Date(xmin_var) + 10, y=9500,
            label=paste(
              comma(cumulative_cases), " cases", "\n",
              comma(active_cases, accuracy=1), " active", "\n",
              comma(daily_cases, accuracy=1), " new",
              sep="")
          ),
          color="#000000", hjust=.05, vjust=1, size=3.5
) +
theme(
  strip.background=ggplot2::element_blank(),
  strip.text=ggplot2::element_text(size =13, hjust=0, face="bold"),
  panel.border=ggplot2::element_blank()
) +
facet_wrap(.~rha)

wfp_rha_active_cases <- prepare_plot(p_rha_active_cases)
ggsave_pngpdf(wfp_rha_active_cases, "wfp_rha_active_cases", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

ggsave_pngpdf(wfp_rha_active_cases, "wfp_mb_health_region_active", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
