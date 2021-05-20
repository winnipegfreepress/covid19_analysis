
plot_bar_x_reordered_y_stacked_pct <- function(
  df, x_var="", xreorder_var="", y_var="", colour_var="", fill_var="", group_var="",
  bar_colour="",
  title_str="", subtitle_str="", x_str="", y_str="", y_units="", ymin="", ymax="",
  source_str="", lastupdate_str=""
) {

  if(bar_colour == ""){
    bar_colour=wfp_blue
  }

  bar_plot <- ggplot2::ggplot(data=df) +
    aes(x=reorder({{ x_var }}, {{ xreorder_var }}), y= {{ y_var }}, color=factor({{colour_var}}), fill=factor({{fill_var}})) +
    geom_col(size=.05) +
    scale_y_continuous(
      expand=c(0, 0),
      limits=c({{ymin}}, {{ymax}}),
      labels=function(x) {
        ifelse(x == {{ymax}}, paste(x, "%", sep=""), x)
      }
    ) +
    coord_flip() +
    labs(
      title=wrap_text(title_str, 70),
      subtitle=wrap_text(subtitle_str, 80),
      caption=wrap_text(toupper(paste("WINNIPEG FREE PRESS — SOURCE: ", source_str, " (", lastupdate_str, ")",sep="")), 80),
      x=x_str,
      y=y_str,
      fill=""
    ) +
    minimal_theme() +
    theme(
      axis.ticks=element_blank(),
      panel.grid.major=ggplot2::element_blank(),
      panel.grid.minor=ggplot2::element_blank()
    )

  return(bar_plot)

}
