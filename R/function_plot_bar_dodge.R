
plot_bar_dodge <- function(
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
      stat="identity", position="dodge",
      size=.25, alpha=1) +
    scale_y_continuous(
      expand=c(0, 0),
      limits=c(ymin, ymax),
      labels=scales::comma
    ) +
    labs(
      title=wrap_text(title_str, 68),
      subtitle=wrap_text(subtitle_str, 80),
      caption=wrap_text(toupper(paste(credit_str, " — SOURCE: ", source_str, " (", lastupdate_str, ")",sep="")), 100),
      x=x_str,
      y=y_str,
      fill=""
    ) +
    minimal_theme()

  invisible(p_tmp)

}
