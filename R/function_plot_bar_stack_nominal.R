
plot_bar_stack_nominal <- function(
  df, x_var="", y_var="", colour_var="", fill_var="", group_var="",
  bar_colour="",
  title_str="", subtitle_str="", x_str="", y_str="",
  x_units="", xmin="", xmax="", xformat="",
  y_units="", ymin="", ymax="",
  source_str="", lastupdate_str=""
) {

  p_tmp <- ggplot2::ggplot(data=df) +
    aes(x={{ x_var }}, y= {{ y_var }}, color=factor({{colour_var}}), fill=factor({{fill_var}})) +
    geom_bar(
      aes(x={{ x_var }}, y= {{ y_var }}, color=factor({{colour_var}}), fill=factor({{fill_var}})
      ),
      stat="identity",
      size=.25, alpha=1) +
    # scale_x_date(
    #   expand=c(0, 0),
    #   limits=as.Date(c({{xmin}},{{xmax}})),
    #   date_breaks={{x_units}},
    #   labels=date_format({{xformat}})
    # ) +
    scale_y_continuous(
      expand=c(0, 0),
      limits=c(ymin, ymax),
      labels=scales::comma
    ) +
    labs(
      title=wrap_text(title_str, 70),
      subtitle=wrap_text(subtitle_str, 85),
      caption=wrap_text(toupper(paste(credit_str, " — SOURCE: ", source_str, " (", lastupdate_str, ")",sep="")), 80),
      x=x_str,
      y=y_str,
      fill=""
    ) +
    minimal_theme()

  invisible(p_tmp)

}
