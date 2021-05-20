
p_daily_hospitalization_total <- plot_bar_stack(
  wfp_daily_hospitalization_total_active_tall,
  x_var=date,
  y_var=cnt,
  colour_var=type,
  fill_var=type,
  group_var="",
  bar_colour=nominalMuted_shade_0,
  title_str="Hospitalizations and ICU admissions of active  and contagious COVID-19 cases in Manitoba",
  # subtitle_str="Shared Health reports hospitalizations for cases considered active and contagious", x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="1 month",
  ymin=0, ymax=800, y_units="",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)


# p_daily_hospitalization <- p_daily_hospitalization +
#   scale_colour_manual(values=c(
#         "Non-ICU"=nominalMuted_shade_0,
#         "Non-ICU (active)"=nominalBold_shade_0,
#         "ICU"=nominalMuted_shade_1,
#         "ICU (active)"=nominalBold_shade_1
#       )
#   ) +
#   scale_fill_manual(
#       # name="March 11, 2021",
#       values=c(
#         "Non-ICU"=nominalMuted_shade_0,
#         "Non-ICU (active)"=nominalBold_shade_0,
#         "ICU"=nominalMuted_shade_1,
#         "ICU (active)"=nominalBold_shade_1
#       ),
#       labels=c(
#         paste(comma(comma(wfp_daily_totals_last_date$total_hospital), "total hospitalizations", sep=" "),
#         paste(comma(wfp_daily_totals_last_date$active_hospital), "active/contagious", sep=" "),
#         paste(comma(wfp_daily_totals_last_date$total_icu), "total ICU", sep=" "),
#         paste(comma(wfp_daily_totals_last_date$active_icu), "active/contagious", sep=" ")
#
#
#     )
#   ) +
#   guides(colour=FALSE) +
#   theme(
#     legend.title=ggplot2::element_text(face="bold"),
#     legend.position=c(.98, 1),
#     legend.justification=c("right", "top"),
#     legend.box.just="right",
#     legend.margin=margin(10, 10, 10, 10)
#   )

ggplot(wfp_daily_hospitalization_total_active_tall) +
  aes(x=date, y=cnt, fill=factor(type), weight=cnt) +
  geom_bar(stat="identity", position="stack") +
  scale_fill_hue() +
  theme_minimal() %>%
plot()


wfp_daily_hospitalization_total <- prepare_plot(p_daily_hospitalization_total)

ggsave_pngpdf(wfp_daily_hospitalization_total, "wfp_daily_hospitalization_total", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(wfp_daily_hospitalization_total, "wfp_daily_hospitalization_total_type", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

