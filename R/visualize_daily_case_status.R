
if(wfp_daily_totals_last_date$new_daily_cases < 1){
  fill_legend_title_cases <- "No new cases of COVID-19 reported"
}

if(wfp_daily_totals_last_date$new_daily_cases == 1){
    fill_legend_title_cases <- paste(wfp_daily_totals_last_date$new_daily_cases, " new case of COVID-19", sep="")
}

if(wfp_daily_totals_last_date$new_daily_cases > 1){
  fill_legend_title_cases <- paste(wfp_daily_totals_last_date$new_daily_cases, " new cases of COVID-19", sep="")
}

if(wfp_daily_totals_last_date$new_daily_deaths < 1){
  fill_legend_title_deaths <- "no new COVID-19 deaths"
}

if(wfp_daily_totals_last_date$new_daily_deaths == 1){
  fill_legend_title_deaths <- paste(wfp_daily_totals_last_date$new_daily_deaths, " new death", sep="")
}

if(wfp_daily_totals_last_date$new_daily_deaths > 1){
  fill_legend_title_deaths <- paste(wfp_daily_totals_last_date$new_daily_deaths, " new deaths", sep="")
}


fill_legend_title_str <- paste(fill_legend_title_cases, "and", fill_legend_title_deaths, sep=" ")

p_daily_case_status <- plot_bar_stack(
  wfp_daily_status_tall,
  x_var=date,
  y_var=cnt,
  colour_var=type,
  fill_var=type,
  group_var="",
  bar_colour=nominalMuted_shade_0,
  title_str="Daily status of COVID-19 cases reported in Manitoba",
  subtitle_str=summary_str, x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="1 month",
  ymin=0, ymax=200000, y_units="",
  source_str="Manitoba Health COVID-19 Bulletin", lastupdate_str=last_update_timestamp
)

p_daily_case_status <- p_daily_case_status +
  scale_colour_manual(values=c(
      "deaths"=nominalMuted_shade_1,
      "recovered"=nominalMuted_shade_2,
      "active"=nominalMuted_shade_0
      )
    ) +
  scale_fill_manual(
      name=fill_legend_title_str,
      values=c(
      "deaths"=nominalMuted_shade_1,
      "recovered"=nominalMuted_shade_2,
      "active"=nominalMuted_shade_0
      ),
      labels=c(
        paste(comma(wfp_daily_totals_last_date$deaths), "deaths", sep=" "),
        paste(comma(wfp_daily_totals_last_date$recovered), "recovered", sep=" "),
        paste(comma(wfp_daily_totals_last_date$active), "active", sep=" ")
      )
    ) +
    guides(colour=FALSE) +
    theme(
      legend.title=ggplot2::element_text(face="bold"),
      legend.position=c(.6, 1.02),
      legend.justification=c("right", "top"),
      legend.box.just="right",
      legend.margin=margin(10, 10, 10, 10)
    )


wfp_daily_case_status <- prepare_plot(p_daily_case_status)

ggsave_pngpdf(wfp_daily_case_status, "wfp_daily_case_status", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(wfp_daily_case_status, "wfp-covid-19-daily-caseload-cumulative-web", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
