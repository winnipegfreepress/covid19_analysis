covid19_variants <- covid19_variants %>%
  mutate(count=ifelse(is.na(count), 0, count))

covid19_variants_mb_b117 <- covid19_variants %>% filter(variant=="B.1.1.7") %>% filter(province == "Manitoba") %>% select(count) %>% pull()
covid19_variants_mb_B1351 <- covid19_variants %>% filter(variant=="B.1.351") %>% filter(province == "Manitoba") %>% select(count) %>% pull()
covid19_variants_mb_p1 <- covid19_variants %>% filter(variant=="P.1") %>% filter(province == "Manitoba") %>% select(count) %>% pull()
covid19_variants_mb_b1617 <- covid19_variants %>% filter(variant=="B.1.617") %>% filter(province == "Manitoba") %>% select(count) %>% pull()
covid19_variants_mb_unknown <- covid19_variants %>% filter(variant=="Uncategorized") %>% filter(province == "Manitoba") %>% select(count) %>% pull()

p_covid19_variants <- plot_bar_x_reordered_y_stacked(
  covid19_variants %>% filter(province!="Canada"),
  x_var=province,
  y_var=count,
  xreorder_var=count,
  colour_var=variant,
  fill_var=variant,
  group_var="",
  bar_colour=nominalBold_shade_0,
  title_str="Cases of COVID-19 variants of concern reported in Canada",
  subtitle_str="Total count of reported cases",
  x_str="", y_str="",
  ymin=0, ymax=200000, y_units="",
  source_str="Provincial health agencies", lastupdate_str=last_update_timestamp
)

p_covid19_variants <- p_covid19_variants +
  geom_text(
    aes(x=reorder(province, total), y=total, label=comma(total, accuracy=1)),
    size=4, hjust=-.25, colour="#000000"
  ) +
  scale_colour_manual(
    name="Manitoba",
    values=c(
      "B.1.1.7"=nominalBold_shade_0,
      "B.1.351"=nominalBold_shade_1,
      "P.1"=nominalBold_shade_2,
      "B.1.617"=nominalBold_shade_3,
      "Uncategorized"="#cecece"
    ),
    labels=c(
      paste(comma(covid19_variants_mb_b117), " cases of B.1.1.7", sep=""),
      paste(comma(covid19_variants_mb_B1351), " cases of B.1.351", sep=""),
      paste(comma(covid19_variants_mb_p1), " cases of P.1", sep=""),
      paste(comma(covid19_variants_mb_b1617), " cases of B.1.617", sep=""),
      paste(comma(covid19_variants_mb_unknown), " uncategorized cases", sep="")
    )
  ) +
  scale_fill_manual(
    name="Manitoba",
    values=c(
      "B.1.1.7"=nominalBold_shade_0,
      "B.1.351"=nominalBold_shade_1,
      "P.1"=nominalBold_shade_2,
      "B.1.617"=nominalBold_shade_3,
      "Uncategorized"="#cecece"
    ),
    labels=c(
      paste(comma(covid19_variants_mb_b117), " cases of B.1.1.7", sep=""),
      paste(comma(covid19_variants_mb_B1351), " cases of B.1.351", sep=""),
      paste(comma(covid19_variants_mb_p1), " cases of P.1", sep=""),
      paste(comma(covid19_variants_mb_b1617), " cases of B.1.617", sep=""),
      paste(comma(covid19_variants_mb_unknown), " uncategorized cases", sep="")
    )
  ) +
  guides(colour=FALSE) +
  theme(
    legend.position=c(.75, .55),
    legend.justification=c("right", "top"),
    legend.box.just="right",
    legend.margin=margin(10, 10, 10, 10),
    panel.grid.major.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank(),
    axis.ticks.y=element_blank()
  )

wfp_covid19_variants <- prepare_plot(p_covid19_variants)
ggsave_pngpdf(wfp_covid19_variants, "wfp_covid19_variants", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

#
# p_covid19_variants_per100K <- ggplot(covid19_variants) +
#   aes(x=reorder(province, total), y=per_capita) +
#   geom_bar(stat="identity", fill=wfp_blue) +
#   geom_text(
#     aes(x=reorder(province, total), label=comma(per_capita, accuracy=1)),
#     size=4, hjust=-.25, colour="#000000"
#   ) +
#   coord_flip() +
#   minimal_theme() +
#   theme(
#     legend.position=c(.75, .55),
#     legend.justification=c("right", "top"),
#     legend.box.just="right",
#     legend.margin=margin(10, 10, 10, 10),
#     panel.grid.major.x=ggplot2::element_blank(),
#     panel.grid.major.y=ggplot2::element_blank(),
#     panel.grid.minor.x=ggplot2::element_blank(),
#     panel.grid.minor.y=ggplot2::element_blank()
#     # axis.ticks.y=element_blank()
#   ) +
#   labs(
#     title=wrap_text("Confirmed cases of COVID-19 variants per 100,000 people", 70),
#     subtitle="",
#     caption=wrap_text(paste(toupper("WINNIPEG FREE PRESS — SOURCE: PROVINCIAL HEALTH AGENCIES"), sep=""), 120),    x="",
#     y="",
#     colour="",
#     fill=""
#   ) +
#   facet_wrap(.~variant) +
#   theme(
#     strip.background=ggplot2::element_blank(),
#     strip.text=ggplot2::element_text(size =13, hjust=0, face="bold"),
#     panel.border=ggplot2::element_blank()
#   )
#
# wfp_covid19_variants_per100K <- prepare_plot(p_covid19_variants_per100K)
# ggsave_pngpdf(wfp_covid19_variants_per100K, "wfp_covid19_variants_per100K", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
