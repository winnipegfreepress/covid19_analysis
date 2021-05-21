
plot_bar_x_reordered_y <- function(
  df, x_var="", y_var="", colour_var="", fill_var="", group_var="",
  bar_colour="",
  title_str="", subtitle_str="", x_str="", y_str="", y_units="", ymin="", ymax="",
  source_str="", lastupdate_str=""
) {

  if(bar_colour == ""){
    bar_colour=wfp_blue
  }


  bar_plot <- ggplot2::ggplot(data=df) +
    aes(x=reorder({{ x_var }}, {{ y_var }}), y= {{ y_var }}) +
    geom_col(colour={{bar_colour}}, fill={{bar_colour}}, size=.05) +
    scale_y_continuous(
      expand=c(0, 0),
      limits=c(ymin, ymax),
      labels=scales::comma
      # labels=function(x) {
      #   ifelse(x == 100, paste(x, "%", sep=""), x)
      # }
    ) +
    coord_flip() +
    minimal_theme() +
    theme(
      axis.line=element_blank(),
      axis.text.x=element_blank(),
      axis.ticks=element_blank(),
      axis.title.x=element_blank(),
      panel.grid.major.y=ggplot2::element_blank(),
      panel.grid.minor.y=ggplot2::element_blank(),
    )

  if(!is.na(subtitle_str) && subtitle_str != ""){
    bar_plot <- bar_plot +
      labs(
        title=wrap_text(title_str, 65),
        subtitle=wrap_text(subtitle_str, 80),
        caption=wrap_text(toupper(paste("WINNIPEG FREE PRESS — SOURCE: ", source_str, " (", lastupdate_str, ")",sep="")), 80),
        x=x_str,
        y=y_str,
        fill=""
      )
  }

  if(is.na(subtitle_str) || subtitle_str == ""){
    bar_plot <- bar_plot +
      labs(
        title=wrap_text(title_str, 65),
        caption=wrap_text(toupper(paste("WINNIPEG FREE PRESS — SOURCE: ", source_str, " (", lastupdate_str, ")",sep="")), 120),
        x=x_str,
        y=y_str,
        fill=""
      )
  }

  return(bar_plot)

}
