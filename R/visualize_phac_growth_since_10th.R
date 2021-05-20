
p_provincial_growth_timeline_since10 <- ggplot(phac_growth_since_10__tall,
                                                  aes(x=days_since_10, y=cumsum, group=province
                                                  )) +
  geom_line(
    data=phac_growth_since_10__tall %>% filter(province !="MB"),
    aes(  x=days_since_10,
          y=cumsum,
          group=province
    ),
    color="#c9c9c9",
    size=.75,
    alpha=1
  ) +
  geom_line(
    data=phac_growth_since_10__tall %>% filter(province =="MB"),
    aes(  x=days_since_10,
          y=cumsum,
          group=province
    ),
    color=wfp_blue,
    size=1,
    alpha=1
  ) +
  geom_point(data=phac_growth_since_10__tall_lastval %>% filter(province !="MB"),
             mapping=aes(x=days_since_10, y=cumsum, label=province),
             alpha=1,
             fill="#999999",
             shape=21,
             colour="#999999",
             size=1
  ) +
  geom_point(data=phac_growth_since_10__tall_lastval %>% filter(province =="MB"),
             mapping=aes(x=days_since_10, y=cumsum, label=province),
             alpha=1,
             fill=wfp_blue,
             shape=21,
             colour=wfp_blue,
             size=1.2
  ) +
  geom_text_repel(
    data=phac_growth_since_10__tall_lastval,
    aes(
      x=days_since_10,
      y=cumsum,
      group=province,
      label=province,
      fontface=ifelse(province=="MB", "bold", "plain")
    ),
    color="#222222",
    size=4,
    hjust=-.75,
    # vjust=-.25,
    direction="y",
    segment.color="#222222",
    segment.size=.2,
    show.legend=FALSE
  ) +
  scale_x_continuous(
    expand=c(0, 0),
    limits=c(0, 450),
    labels=scales::comma) +
  scale_y_continuous(
    trans="log10",
    expand=c(0, 0),
    limits=c(10, 1000000),
    breaks=c(10,1000,10000,100000,250000, 500000, 1000000),
    labels=scales::comma) +
  labs(
    title="Growth of reported COVID-19 cases in Canada",
    subtitle="",
    caption=wrap_text(
      paste("A logarithmic scale is used for analysis when data contains a large range of values. Axis ticks increase by a factor (10) of the base of the logarithm instead of in equal linear increments.",
            "\n\n",
            "WINNIPEG FREE PRESS — SOURCE: PUBLIC HEALTH AGENCY OF CANADA (", last_update_timestamp, ")", sep=""),120
    ),
    x="Days since the tenth case",
    y="Number of cases (log10)"
  ) +
  minimal_theme()


wfp_provincial_growth_timeline_since10 <- prepare_plot(p_provincial_growth_timeline_since10)
ggsave_pngpdf(wfp_provincial_growth_timeline_since10, "wfp_provincial_growth_timeline_since10", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

