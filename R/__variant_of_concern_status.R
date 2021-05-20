
dashboard_variants_of_concern_type <- dashboard_variants_of_concern %>%
  select(variant, cases) %>%
  group_by(variant) %>%
  summarize(
    total=sum(cases, na.rm=TRUE)
  )


dashboard_variants_of_concern_transmission <- dashboard_variants_of_concern %>%
  select(-object_id) %>%
  group_by(rha, variant, staging) %>%
  summarize(
    total=sum(cases, na.rm=TRUE)
  ) %>%
  pivot_wider(
    names_from=rha,
    values_from=total
  ) %>%
  clean_names() %>%
  mutate(
    voc_cases_total=interlake_eastern + northern + prairie_mountain_health + southern_health_sante_sud + winnipeg
  ) %>%
  select(
    variant, staging, voc_cases_total
  )




p_variants_of_concern_transmission <- ggplot(dashboard_variants_of_concern_transmission) +
  aes(x=variant, y=voc_cases_total, group=variant) +
  geom_bar(stat="identity", colour=wfp_blue, fill=wfp_blue) +
  geom_text(
    aes(x=variant, y=voc_cases_total, group=variant, label=voc_cases_total),
    stat="identity", size=4, vjust=-.5) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0,800),
    labels=scales::comma
  ) +
  labs(
    title=wrap_text("Most likely acquisition type for reported COVID-19 variant of concern cases in Manitoba", 65),
    caption=wrap_text(toupper(paste("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH (2021-04-27)", sep="")), 80),
    x="",
    y="",
    fill=""
  ) +
  minimal_theme() +
  theme(
    plot.title=ggplot2::element_text(size=18, margin=ggplot2::margin(0,0,10,0)),
    strip.background=ggplot2::element_blank(),
    strip.text=ggplot2::element_text(size =13, hjust=0, face="bold"),
    panel.border=ggplot2::element_blank()
  ) +
  facet_wrap(~staging)

wfp_variants_of_concern_transmission <- prepare_plot(p_variants_of_concern_transmission)

ggsave_pngpdf(wfp_variants_of_concern_transmission, "wfp_variants_of_concern_transmission", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

