
plot_bignumber_abs_pctchg <-  function(sum_val="", sum_unit_str="", sum_unit_period="", pctchg_sym_val="", colour_val="", pct_chg_val="", pct_chg_str_val=""){

  # if(sum_unit_period == ""){
  #   sum_unit_period <- "FOO in previous 14 days"
  # }

  plot_tmp <- ggplot2::ggplot() +
    annotate(geom="text", x=4, y=14,label=paste(comma({{sum_val}}), sep=" "), size=5.5, fontface="bold", hjust=1) +
    annotate(geom="text", x=6, y=14,label={{sum_unit_str}}, lineheight=.8, size=2.5, fontface="bold", hjust=1) +
    annotate(geom="text", x=6, y=0,label=paste({{sum_unit_period}}, sep=""), size=2.75,  hjust=1, vjust=-1, colour="#666666")

  if (pctchg_sym_val != "") {
    plot_tmp <- plot_tmp +
      annotate(geom = "text", x = 6.25, y = 14, label = sprintf({{ pctchg_sym_val }}), size = 8.5, fontface = "bold", hjust = 0, colour = colour_val, fill = colour_val)
  }

  plot_tmp <-  plot_tmp +
    annotate(geom="text", x=10, y=14,label=paste(abs(round({{pct_chg_val}}, digits=1)), "%", sep=""), size=5.5, fontface="bold", hjust=1) +
    annotate(geom="text", x=10, y=0, label={{pct_chg_str_val}}, size=2.75,  lineheight=1, hjust=1, vjust=-1, colour="#666666") +

    scale_x_continuous(expand=c(0, 0), limits=c(0, 10)) +
    scale_y_continuous(expand=c(0, 0), limits=c(0, 20)) +
    minimal_theme() +
    theme(
      axis.title=element_blank(), axis.text=element_blank(),
      axis.line=element_blank(), axis.ticks=element_blank(),
      plot.margin=unit(c(0,0,0,0),"cm"),
      plot.title=ggplot2::element_text(size=15,margin=ggplot2::margin(0,0,10,0), colour="#000000"),
      plot.subtitle=ggplot2::element_text(size=10, margin=ggplot2::margin(0,0,.25,0), colour="#666666"),
      panel.grid.major.x=ggplot2::element_blank(), panel.grid.minor.x=ggplot2::element_blank(),
      panel.grid.major.y=ggplot2::element_blank(), panel.grid.minor.y=ggplot2::element_blank()
    )

  invisible(plot_tmp)

}



################################################################################
# COVID-19 at a glance -- big numbers
################################################################################

# plot_bignumber_abs_pctchg(sum_val="", pctchg_sym_val="", latest_14day_cases_pct_chg_val="", latest_14day_cases_pct_chg_str_val="")
p_covid19_14day_cases  <- plot_bignumber_abs_pctchg(sum_val=latest_daily_cases, sum_unit_str="cases\ntoday",
                                                    sum_unit_period=paste(comma(cumsum_cases), "cases to date", sep=" "),
                                                    pctchg_sym_val=latest_14day_cases_pct_chg_sym,
                                                    colour_val=latest_14day_cases_pct_chg_sym_colour,
                                                    pct_chg_val=latest_14day_cases_pct_chg,
                                                    pct_chg_str_val=latest_14day_cases_pct_chg_str)

p_covid19_14day_deaths  <- plot_bignumber_abs_pctchg(sum_val=latest_daily_deaths, sum_unit_str="deaths\ntoday",
                                                     sum_unit_period=paste(comma(cumsum_deaths), "deaths to date", sep=" "),
                                                     pctchg_sym_val=latest_14day_deaths_pct_chg_sym, colour_val=latest_14day_deaths_pct_chg_sym_colour,
                                                     pct_chg_val=latest_14day_deaths_pct_chg,
                                                     pct_chg_str_val=latest_14day_deaths_pct_chg_str)

p_covid19_14day_1stdose  <-  plot_bignumber_abs_pctchg(sum_val=latest_14day_doses_first_sum, sum_unit_str="first\ndoses",
                                                     sum_unit_period="in previous 14 days",
                                                     pctchg_sym_val=latest_14day_doses_first_pct_chg_sym, colour_val=latest_14day_doses_first_pct_chg_sym_colour,
                                                     pct_chg_val=latest_14day_doses_first_pct_chg,
                                                     pct_chg_str_val=latest_14day_doses_first_pct_chg_str
                                                     )

#   plot_bignumber_abs_pctchg(sum_val=latest_14day_doses_first_sum, sum_unit_str="first\ndoses",
# sum_unit_period="in previous 14 days",  pct_chg_val=latest_14day_doses_first_pct_chg, pct_chg_str_val=latest_14day_doses_first_pct_chg_str)

p_covid19_cumsum_1stdose  <- plot_bignumber_abs_pctchg(sum_val=latest_cumulative_first_doses, sum_unit_str="first\ndoses",
                                                       sum_unit_period="cumulative vaccinations",
                                                       pctchg_sym_val="", colour_val="",
                                                       pct_chg_val=latest_cumulative_first_dose_vaccinations,
                                                       pct_chg_str_val="12+ population")


p_topline_cases_deaths_1st_doses_vertical <-ggarrange(
  p_title.p,
  p_covid19_14day_cases,
  p_covid19_14day_deaths,
  p_covid19_14day_1stdose,
  p_covid19_cumsum_1stdose,
  p_disclaimer.p,
  p_credit_source.p,
  labels=c("", "", ""),
  ncol=1, nrow=7,
  heights=c(.1, .22, .22, .22, .22, .15, .06)
) +
  theme(plot.margin=margin(.2,.2,.2,.2, "cm"))

ggsave_pngpdf(p_topline_cases_deaths_1st_doses_vertical, "p_topline_cases_deaths_1st_doses_vertical", width_var=2.38, height_var=2.8, dpi_var=300, scale_var=1, units_var="in")


