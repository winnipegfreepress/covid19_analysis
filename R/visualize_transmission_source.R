
week_of_date <- wfp_transmission_source_tall %>%  filter(week_of == max(week_of)) %>%  filter(count == max(count)) %>% select(week_of) %>% pull()
as_of_date_str <- week_of_date + 6
as_of_date_str <- format(as_of_date_str, format="%B %d")


p_transmission_source <- ggplot(wfp_transmission_source_tall) +
  aes(x=week_of, y=count, colour=factor(transmission_source), group=transmission_source) +
  geom_line(aes(x=week_of, y=count, colour=factor(transmission_source), group=transmission_source),
            size=1,
            alpha=.6) +
  geom_point(
    aes(x=week_of, y=count, colour=factor(transmission_source), fill=factor(transmission_source), group=transmission_source),
    size=.75,
    shape=21,
    alpha=1) +
  geom_text_repel(
  # geom_text(
    data=wfp_transmission_source_tall %>%  filter(week_of == max(week_of)),
    aes(x=week_of, y=count,
        label=paste(transmission_source, ": ", count, "%", sep="")
    ),
    color="#222222",
    force=10,
    size=4,
    hjust=-.25,
    vjust=-.25,
    direction="y",
    segment.color="#999999",
    segment.size=.2,
    show.legend=FALSE
  ) +
  geom_point(
    data=wfp_transmission_source_tall %>%  filter(week_of == max(week_of)),
    aes(x=week_of, y=count, colour=factor(transmission_source), fill=factor(transmission_source), group=transmission_source),
    size=1.25,
    shape=21,
    alpha=1) +
  scale_colour_manual(
    values=c(
      "Close contact" = nominalBold_shade_0,
      "Unknown" = nominalBold_shade_1,
      "Investigation pending" = nominalBold_shade_2,
      "Travel" = nominalBold_shade_3
    ),
    guide=FALSE
  ) +
  scale_fill_manual(
    values=c(
      "Close contact" = nominalBold_shade_0,
      "Unknown" = nominalBold_shade_1,
      "Investigation pending" = nominalBold_shade_2,
      "Travel" = nominalBold_shade_3
    ),
    guide=FALSE
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 100),
    labels=function(x) {
      ifelse(x == 100, paste(x, "%", sep=""), x)
    }
  ) +
  scale_x_date(
    expand=c(0, 0),
    limits=c(as.Date("2020-05-01"), as.Date("2021-10-31")),
    date_breaks="1 month",
    date_minor_breaks="1 month",
    labels=date_format("%b")
  ) +
  labs(
    title=wrap_text("Transmission source for COVID-19 cases reported", 70),
    subtitle=paste("As of", as_of_date_str, sep=" "),
    caption=wrap_text(paste(
      toupper("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH (Provincial COVID-19 Surveillance)"), sep=""), 120),
    x="",
    y="",
    colour=""
  ) +
  minimal_theme()


wfp_transmission_source <- prepare_plot(p_transmission_source)
ggsave_pngpdf(wfp_transmission_source, "wfp_transmission_source", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(wfp_transmission_source, "wfp_transmission_source", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

