
################################################################################
# Cumulative first doses per 100K capita
################################################################################
p_first_doses_total <- ggplot(wfp_covid19_topline %>% filter(date >= as.Date(date_min_30days))) +
  aes(x=date, y=cumulative_first_doses_per_100K) +
  geom_line(stat="identity", size=.5, colour=wfp_blue) +
  geom_point(data=wfp_covid19_topline %>% filter(date==max(date)),
             aes(x=date, y=cumulative_first_doses_per_100K),
             stat="identity", size=1, colour=wfp_blue
  ) +
  geom_text(data=wfp_covid19_topline %>% filter(date==max(date)),
            aes(x=date, y=cumulative_first_doses_per_100K,
                label=paste(
                    round(latest_cumulative_first_doses_per_100K / 100000 * 100, digits=1), "%",
                    sep=""
                  ),
            ),
            size=6, fontface="bold", vjust=-3.25
  ) +
  geom_text(data=wfp_covid19_topline %>% filter(date==max(date)),
            aes(x=date, y=cumulative_first_doses_per_100K,
                label=wrap_text(paste("of eligible population vaccinated with a first dose", sep=""), 32),
            ),
            size=3.5, vjust=-.6, lineheight=1.1
  ) +

  scale_x_date(
    expand=c(0, 0),
    limits=c(as.Date(date_min_30days), as.Date(date_max_15)),
    # date_breaks="1 month",
    # labels=date_format("%B %d")
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 100000),
    labels=scales::comma
  ) +
  labs(
    title=paste(comma(latest_cumulative_first_doses_per_100K), " first doses per capita", sep=""),
    subtitle="First doses administered to eligible population",
    # caption="",
    x="",
    y="",
    fill=""
  ) +
  minimal_theme() +
  theme(
    axis.line=element_blank(),
    # axis.ticks=element_blank(),
    # axis.title.x=element_blank(),
    # axis.text.x=element_blank(),
    plot.margin=unit(c(0.25,0,0,0),"cm"),
    plot.title=ggplot2::element_text(size=20,margin=ggplot2::margin(0,0,0,0)),
    plot.subtitle=ggplot2::element_text(margin=ggplot2::margin(0,0,15,0), colour="#777777"),
    axis.ticks=ggplot2::element_line(color="#9c9c9c"),
    panel.grid.major.x=ggplot2::element_blank(),
    panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank()
  )

p_first_doses_total <- prepare_plot(p_first_doses_total)

plot(p_first_doses_total)
