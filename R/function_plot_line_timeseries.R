
plot_line_timeseries <- function(
  df, x_var="", y_var="", colour_var="", fill_var="", group_var="",
  line_colour="", line_size=1, line_geom="line",
  title_str="", subtitle_str="", x_str="", y_str="",
  x_units="", xmin="", xmax="", xformat="",
  y_units="", ymin="", ymax="",
  source_str="", lastupdate_str=""
) {

  p_tmp <- ggplot2::ggplot(data=df) +
    aes(x={{ x_var }}, y= {{ y_var }})

  if(line_geom == "step"){
    p_tmp <- p_tmp +
      geom_step(
        aes(x={{ x_var }}, y= {{ y_var }}),
        stat="identity",
        color={{line_colour}},
        # fill={{line_colour}},
        size={{line_size}}, alpha=1,
        direction="vh"
        )
  }
  else{
    p_tmp <- p_tmp +
      geom_line(
        aes(x={{ x_var }}, y= {{ y_var }}),
        stat="identity",
        color={{line_colour}},
        # fill={{line_colour}},
        size={{line_size}}, alpha=1)

  }

  p_tmp <- p_tmp +
    scale_x_date(
      expand=c(0, 0),
      limits=as.Date(c({{xmin}},{{xmax}})),
      date_breaks={{x_units}},
      labels=date_format({{xformat}})
    ) +
    scale_y_continuous(
          expand=c(0, 0),
          limits=c(ymin, ymax),
          labels=scales::comma
    ) +
    labs(
      title=wrap_text(title_str, 70),
      subtitle=wrap_text(subtitle_str, 80),
      caption=wrap_text(toupper(paste(credit_str, " — SOURCE: ", source_str, " (", lastupdate_str, ")",sep="")), 80),
      x=x_str,
      y=y_str,
      fill=""
    ) +
    minimal_theme()

  invisible(p_tmp)

}
