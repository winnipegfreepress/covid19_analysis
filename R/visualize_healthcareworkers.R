
week_of_date <- wfp_healthcareworkers_tall %>%  filter(week_of == max(week_of)) %>%  head(1) %>% select(week_of) %>% pull()
as_of_date_str <- week_of_date + 6
as_of_date_str <- format(as_of_date_str, format="%B %d, %Y")


p_healthcareworkers <- ggplot(wfp_healthcareworkers_tall %>% filter(hcw_role %in% c("Allied health professional", "Nurse", "Physician/Physician in training", "First responder", "Not identified"))) +
  aes(x=week_of, y=count, colour=factor(hcw_role), group=hcw_role) +
  geom_line(aes(x=week_of, y=count, colour=factor(hcw_role), group=hcw_role),
            size=1,
            alpha=.6) +
  geom_point(
    aes(x=week_of, y=count, colour=factor(hcw_role), fill=factor(hcw_role), group=hcw_role),
    size=.75,
    shape=21,
    alpha=1) +
  geom_text(
    data=wfp_healthcareworkers_tall %>%  filter(week_of == max(week_of)),
    aes(x=week_of, y=count,
        label=paste(hcw_role, ": ", count, sep="")
    ),
    # color="#222222",
    # size=4,
    # hjust=-.3,
    # vjust=0,
    # direction="y",
    # segment.color="#999999",
    # segment.size=.2,
    # show.legend=FALSE
    point.padding=NA,
    color="#222222",
    # nudge_x      =3,
    # nudge_y      =3,
    size=4,
    hjust=-.05,
    vjust=0,
    direction="y",
    segment.color="#777777",
    segment.size=.2,
    show.legend=FALSE
  ) +
  geom_point(
    data=wfp_healthcareworkers_tall %>%  filter(week_of == max(week_of)),
    aes(x=week_of, y=count, colour=factor(hcw_role), fill=factor(hcw_role), group=hcw_role),
    size=1.25,
    shape=21,
    alpha=1) +
  scale_colour_manual(
    values=c(
      "Allied health professional" = nominalBold_shade_0,
      "Nurse" = nominalBold_shade_1,
      "Physician/Physician in training" = nominalBold_shade_2,
      "First responder" = nominalBold_shade_3,
      "Not identified"=  nominalBold_shade_4,
      "Other"="#555555",
      "Health care aide"="#777777"
    ),
    guide=FALSE
  ) +
  scale_fill_manual(
    values=c(
      "Allied health professional" = nominalBold_shade_0,
      "Nurse" = nominalBold_shade_1,
      "Physician/Physician in training" = nominalBold_shade_2,
      "First responder" = nominalBold_shade_3,
      "Not identified"=  nominalBold_shade_4,
      "Other"="#555555",
      "Health care aide"="#777777"
    ),
    guide=FALSE
  ) +
  scale_y_continuous(expand=c(0, 0), limits=c(0, 1500)) +
  scale_x_date(
    expand=c(0, 0),
    limits=c(as.Date("2020-05-01"), as.Date("2021-12-31")),
    date_breaks="1 month",
    date_minor_breaks="1 month",
    labels=date_format("%b")
  ) +
  labs(
    title=wrap_text("Reported COVID-19 cases among health-care workers", 70),
    subtitle=paste("As of", as_of_date_str, sep=" "),
    caption=wrap_text(paste(
      "\n", "Allied health professional includes social and support workers, lab and x-ray technicians, pharmacists, medical clerks and individuals in easily-identified roles.", "\n\n",
    toupper("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH (Provincial COVID-19 Surveillance Report)"), sep=""), 120),    x="",
    y="",
    colour=""
  ) +
  minimal_theme()



wfp_healthcareworkers <- prepare_plot(p_healthcareworkers)
ggsave_pngpdf(wfp_healthcareworkers, "wfp_healthcareworkers", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

# plot(wfp_healthcareworkers)
