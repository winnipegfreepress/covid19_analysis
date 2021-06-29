library(readr)
WFP_Contact_summary_in_new_cases <- read_csv("data/raw/WFP - Contact summary in new cases - Sheet1.csv") %>%
  clean_names()

# View(WFP_Contact_summary_in_new_cases)

p_contact_summary_in_new_cases <- ggplot(WFP_Contact_summary_in_new_cases) +
  aes(x = week_of, y = maximum_contacts) +
  geom_line(size = 1, color=wfp_blue) +
  geom_text(
    data=WFP_Contact_summary_in_new_cases %>% filter(week_of == max(week_of)),
  aes(x = week_of, y = maximum_contacts, label=maximum_contacts),
  size = 4, color="#000000",
  hjust=-.25, vjust=.5) +

  annotate("text",
           x=as.Date("2021-04-25"),
           y=150,
           label=wrap_text("Additional restrictions", 20),
           hjust=1, vjust=.5, lineheight=1.1,
           size=3.5,
           colour="#555555"
  ) +
  annotate("segment",
           x=as.Date("2021-04-26"),
           y=200,
           xend=as.Date("2021-04-26"),
           yend=0,
           size=.25,
           alpha= 1,
           linetype="dotted",
           colour="#555555"
  ) +

  annotate("text",
           x=as.Date("2021-05-21"),
           y=150,
           label=wrap_text("Additional restrictions", 20),
           hjust=1, vjust=.5, lineheight=1.1,
           size=3.5, lineheight=1.2,
           colour="#555555"
  ) +
  annotate("segment",
           x=as.Date("2021-05-22"),
           y=200,
           xend=as.Date("2021-05-22"),
           yend=0,
           size=.25,
           alpha= 1,
           linetype="dotted",
           colour="#555555"
  ) +

  annotate("text",
           x=as.Date("2021-06-11"),
           y=150,
           label=wrap_text("Restrictions begin easing", 30),
           hjust=-.05, vjust=0,
           size=3.5, lineheight=1.2,
           colour="#555555"
  ) +
  annotate("segment",
           x=as.Date("2021-06-12"),
           y=200,
           xend=as.Date("2021-06-12"),
           yend=0,
           size=.25,
           alpha= 1,
           linetype="dashed",
           colour="#555555"
  ) +

  # scale_color_brewer(palette = "Set2", drop=FALSE) +
  # scale_fill_brewer(palette = "Set2", drop=FALSE) +
  scale_x_date(
    expand=c(0, 0),
    limits=as.Date(c("2021-04-01","2021-07-31")),
    date_breaks="1 month",
    labels=date_format("%B")
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 200),
    breaks=c(0,50,100,150,200)
    # labels=function(x) {
    #   ifelse(x == 100, paste(x, "%", sep=""), x)
    # }
  ) +
  labs(
    # title = "",
    title = wrap_text("Maximum number of contacts for new cases of COVID-19 in Manitoba", 40),
    subtitle = wrap_text("Weekly new cases reported April 11-June 13, 2021. Median contacts are consistently four or fewer per case.", 60),
    caption = wrap_text(paste(toupper("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH"), " (2021-06-28)", sep=""), 120),    x = "",
    x = "",
    y = "",
    colour = "",
    fill=""
  ) +
  minimal_theme() +
  theme(
    legend.position=c(.9, 1),
    legend.justification=c("right", "top"),
    legend.box.just="right",
    legend.margin=margin(10, 10, 10, 10),
    # panel.grid.major.x=ggplot2::element_blank(),
    # panel.grid.major.y=ggplot2::element_blank(),
    # panel.grid.minor.x=ggplot2::element_blank(),
    # panel.grid.minor.y=ggplot2::element_blank(),
    strip.background=ggplot2::element_blank(),
    strip.text=ggplot2::element_text(size =12, hjust=0, face="bold"),
    panel.border=ggplot2::element_blank()
    # axis.ticks.y=element_blank()
  ) +
  facet_wrap(.~regional_health_authority, ncol=1)


wfp_contact_summary_in_new_cases <- prepare_plot(p_contact_summary_in_new_cases)
ggsave_pngpdf(wfp_contact_summary_in_new_cases, "wfp_contact_summary_in_new_cases", width_var=6, height_var=8.66, dpi_var=150, scale_var=1, units_var="in")

