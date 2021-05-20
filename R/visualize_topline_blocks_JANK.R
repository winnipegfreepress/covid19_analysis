

################################################################################
# Seven day sum and pct change on new cases
################################################################################
p_cases_7day <- ggplot(wfp_covid19_topline %>% filter(date >= as.Date(date_min_30days))) +
  aes(x=date, y=cases_7day_sum) +
  geom_line(stat="identity", size=.5, colour=wfp_blue) +
  geom_point(data=wfp_covid19_topline %>% filter(date==max(date)),
             aes(x=date, y=cases_7day_sum),
             stat="identity", size=1, colour=wfp_blue
  ) +
  geom_text(data=wfp_covid19_topline %>% filter(date==max(date)),
            aes(x=date, y=cases_7day_sum,
                label=paste(abs(round(latest_7day_cases_pct_chg, digits=1)), "%", sep=""),
            ),
            size=6, fontface="bold", vjust=-1.75
  ) +
  geom_text(data=wfp_covid19_topline %>% filter(date==max(date)),
            aes(x=date, y=cases_7day_sum,
                label=wrap_text(latest_7day_cases_pct_chg_str, 25)),
            size=3.5, vjust=-1.5, lineheight=1, colour="#777777"
  ) +

  scale_x_date(
    expand=c(0, 0),
    limits=c(as.Date(date_min_30days), as.Date(date_max_15)),
    # date_breaks="1 month",
    # labels=date_format("%B %d")
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 2000),
    labels=scales::comma
  ) +
  labs(
    title=paste(latest_7day_cases_sum, " new cases", sep=""),
    subtitle="in the previous seven days",
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
    plot.margin=unit(c(0,0,0,0),"cm"),
    plot.title=ggplot2::element_text(size=20,margin=ggplot2::margin(0,0,0,0)),
    plot.subtitle=ggplot2::element_text(margin=ggplot2::margin(5,0,15,0), colour="#777777"),
    axis.ticks=ggplot2::element_line(color="#9c9c9c"),
    panel.grid.major.x=ggplot2::element_blank(),
    panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank()
  )

p_cases_7day <- prepare_plot(p_cases_7day)


################################################################################
# Seven day sum and pct change on new deaths
################################################################################
p_deaths_7day <- ggplot(wfp_covid19_topline %>% filter(date >= as.Date(date_min_30days))) +
  aes(x=date, y=deaths_7day_sum) +
  geom_line(stat="identity", size=.5, colour=wfp_blue) +
  geom_point(data=wfp_covid19_topline %>% filter(date==max(date)),
             aes(x=date, y=deaths_7day_sum),
             stat="identity", size=1, colour=wfp_blue
  ) +
  geom_text(data=wfp_covid19_topline %>% filter(date==max(date)),
            aes(x=date, y=deaths_7day_sum,
                label=paste(abs(round(latest_7day_deaths_pct_chg, digits=1)), "%", sep=""),
            ),
            size=6, fontface="bold", vjust=-1.75
  ) +
  geom_text(data=wfp_covid19_topline %>% filter(date==max(date)),
            aes(x=date, y=deaths_7day_sum,
                label=wrap_text(latest_7day_deaths_pct_chg_str, 25)),
            size=3.5, vjust=-1.5, lineheight=1, colour="#777777"
  ) +

  scale_x_date(
    expand=c(0, 0),
    limits=c(as.Date(date_min_30days), as.Date(date_max_15)),
    # date_breaks="1 month",
    # labels=date_format("%B %d")
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 200),
    labels=scales::comma
  ) +
  labs(
    title=paste(latest_7day_deaths_sum, " new deaths", sep=""),
    subtitle="in the previous seven days",
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
    plot.margin=unit(c(0,0,0,0),"cm"),
    plot.title=ggplot2::element_text(size=20,margin=ggplot2::margin(0,0,0,0)),
    plot.subtitle=ggplot2::element_text(margin=ggplot2::margin(5,0,15,0), colour="#777777"),
    axis.ticks=ggplot2::element_line(color="#9c9c9c"),
    panel.grid.major.x=ggplot2::element_blank(),
    panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank()
  )

p_deaths_7day <- prepare_plot(p_deaths_7day)



################################################################################
# Seven day sum and pct change of first doses administered
################################################################################
p_first_doses_7day <- ggplot(wfp_covid19_topline %>% filter(date >= as.Date(date_min_30days))) +
  aes(x=date, y=doses_first_7day_sum) +
  geom_line(stat="identity", size=.5, colour=wfp_blue) +
  geom_point(data=wfp_covid19_topline %>% filter(date==max(date)),
             aes(x=date, y=doses_first_7day_sum),
             stat="identity", size=1, colour=wfp_blue
  ) +
  geom_text(data=wfp_covid19_topline %>% filter(date==max(date)),
            aes(x=date, y=doses_first_7day_sum,
                label=paste(abs(round(doses_first_7day_pctchg, digits=1)), "%", sep=""),
            ),
            size=6, fontface="bold", vjust=-1.75
  ) +
  geom_text(data=wfp_covid19_topline %>% filter(date==max(date)),
            aes(x=date, y=doses_first_7day_sum,
                label=wrap_text(latest_7day_doses_first_pct_chg_str, 25)),
            size=3.5, vjust=-1.5, lineheight=1, colour="#777777"
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
    title=paste(comma(latest_7day_doses_first_sum), " first doses", sep=""),
    subtitle="in the previous seven days",
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
    plot.margin=unit(c(0,0,0,0),"cm"),
    plot.title=ggplot2::element_text(size=20,margin=ggplot2::margin(0,0,0,0)),
    plot.subtitle=ggplot2::element_text(margin=ggplot2::margin(5,0,15,0), colour="#777777"),
    axis.ticks=ggplot2::element_line(color="#9c9c9c"),
    panel.grid.major.x=ggplot2::element_blank(),
    panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank()
  )

p_first_doses_7day <- prepare_plot(p_first_doses_7day)



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
                label=wrap_text(paste("of eligible population vaccinated with a first or second dose", sep=""), 34),
            ),
            size=3.5, vjust=-.6, lineheight=1.1, colour="#777777"
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
    plot.margin=unit(c(0,0,0,0),"cm"),
    plot.title=ggplot2::element_text(size=20,margin=ggplot2::margin(0,0,0,0)),
    plot.subtitle=ggplot2::element_text(margin=ggplot2::margin(5,0,15,0), colour="#777777"),
    axis.ticks=ggplot2::element_line(color="#9c9c9c"),
    panel.grid.major.x=ggplot2::element_blank(),
    panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank()
  )

p_first_doses_total <- prepare_plot(p_first_doses_total)

plot(p_first_doses_total)


################################################################################
# Assemble the plots in a few layouts
################################################################################
p_title <- paste("COVID-19 in Manitoba")
p_title.p <- ggparagraph(text=p_title, face="bold", size=28, color="black", )

p_title_vaccinations <- paste("COVID-19 vaccinations in Manitoba")
p_title_vaccinations.p <- ggparagraph(text=p_title_vaccinations, face="bold", size=28, color="black", )

p_caption=wrap_text(toupper(paste(credit_str, " — SOURCE: ", "Manitoba Health", " (", format(date_max, "%Y-%m-%d"), ")",sep="")), 80)
p_caption.p=ggparagraph(text=p_caption, size=12, color="black", )


p_topline_cases_deaths_doses_2up_cases_deaths <-ggarrange(
  p_cases_7day,
  p_deaths_7day,
  labels=c("", "", ""),
  ncol=2, nrow=1
) +
  theme(plot.margin=margin(0,0,0.05,0, "cm"))

p_topline_cases_deaths_doses_2up_vaccinations <-ggarrange(
  p_first_doses_7day,
  p_first_doses_total,
  labels=c("", "", ""),
  ncol=2, nrow=1
) +
  theme(plot.margin=margin(0,0,0.05,0, "cm"))


p_topline_cases_deaths_1stdoses_3up <-ggarrange(
  p_cases_7day,
  p_deaths_7day,
  p_first_doses_total,
  labels=c("", "", ""),
  ncol=3, nrow=1
) +
  theme(plot.margin=margin(.25,0,0,0, "cm"))



p_topline_cases_deaths_doses_2up2over <-ggarrange(
  p_cases_7day,
  p_deaths_7day,
  p_first_doses_7day,
  p_first_doses_total,
  labels=c("", "", ""),
  ncol=2, nrow=2
) +
  theme(plot.margin=margin(0,0,0.05,0, "cm"))

# Add title and credit line
p_topline_2up_cases_deaths <-ggarrange(
  p_title.p,
  p_topline_cases_deaths_doses_2up_cases_deaths,
  p_caption.p,
  labels=c("", "", ""),
  ncol=1, nrow=3,
  heights=c(0.2, 1.2, .1)
) +
  theme(plot.margin=margin(0.2,0.2,0,0.2, "cm"))

p_topline_2up_vaccinations <-ggarrange(
  p_title_vaccinations.p,
  p_topline_cases_deaths_doses_2up_vaccinations,
  p_caption.p,
  labels=c("", "", ""),
  ncol=1, nrow=3,
  heights=c(0.2, 1.2, .1)
) +
  theme(plot.margin=margin(0.2,0.2,0,0.2, "cm"))

p_topline_3up <-ggarrange(
  p_title.p,
  p_topline_cases_deaths_1stdoses_3up,
  p_caption.p,
  labels=c("", "", ""),
  ncol=1, nrow=3,
  heights=c(0.2, 1.2, .1)
) +
  theme(plot.margin=margin(0.2,0.2,0,0.2, "cm"))

p_topline_2up2over <-ggarrange(
  p_title.p,
  p_topline_cases_deaths_doses_2up2over,
  p_caption.p,
  labels=c("", "", ""),
  ncol=1, nrow=3,
  heights=c(0.12, 1.2, .05)
) +
  theme(plot.margin=margin(0.2,0.2,0,0.2, "cm"))



ggsave_pngpdf(p_topline_2up_cases_deaths, "p_topline_2up_cases_deaths", width_var=8.66, height_var=4, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(p_topline_2up_vaccinations, "p_topline_2up_vaccinations", width_var=8.66, height_var=4, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(p_topline_2up2over, "p_topline_2up2over", width_var=8.66, height_var=8.66, dpi_var=300, scale_var=1, units_var="in")

# ggsave_pngpdf(p_topline_3up, "p_topline_3up", width_var=8.66, height_var=4, dpi_var=300, scale_var=1, units_var="in")




################################################################################
# 7 day deaths
################################################################################
p_deaths_7day <- ggplot() +
  annotate(geom="text", x=0, y=1.4,
           label=sprintf(latest_7day_deaths_pct_chg_sym),
           size=6, fontface="bold", hjust=0
  ) +
  annotate(geom="text", x=0.4, y=1.4,
           label=paste(abs(round(latest_7day_deaths_pct_chg, digits=1)), "%", sep=""),
           size=6, fontface="bold", hjust=0
  ) +
  annotate(geom="text", x=0, y=.45,
           label=latest_7day_deaths_pct_chg_str, size=2.5, lineheight=1,
           hjust=0, colour="#777777"
  ) +
  scale_x_continuous(expand=c(0, 0), limits=c(0, 2)) +
  scale_y_continuous(expand=c(0, 0), limits=c(0, 2)) +
  labs(
    title=paste(latest_7day_deaths_sum, " new deaths", sep=""),
    subtitle="in the previous week", x="", y="", fill=""
  ) +
  minimal_theme() +
  theme(
    # text=element_text(family="Open Sans"),
    axis.title=element_blank(), axis.text=element_blank(),
    axis.line=element_blank(), axis.ticks=element_blank(),
    plot.margin=unit(c(0,0,1,0),"cm"),
    plot.title=ggplot2::element_text(size=16,margin=ggplot2::margin(0,0,0,0), colour="#000000"),
    plot.subtitle=ggplot2::element_text(size=10, margin=ggplot2::margin(0,0,.25,0), colour="#777777"),
    panel.grid.major.x=ggplot2::element_blank(), panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(), panel.grid.minor.y=ggplot2::element_blank()
  )

p_deaths_7day <- prepare_plot(p_deaths_7day)


################################################################################
# 7 day vaccinations
################################################################################
p_vaccinations_7day <- ggplot() +
  annotate(geom="text", x=0, y=1.4,
           label=sprintf(latest_7day_doses_first_pct_chg_sym),
           size=6, fontface="bold", hjust=0
  ) +
  annotate(geom="text", x=0.4, y=1.4,
           label=paste(abs(round(latest_7day_doses_first_pct_chg, digits=1)), "%", sep=""),
           size=6, fontface="bold", hjust=0
  ) +
  annotate(geom="text", x=0, y=.45,
           label=latest_7day_doses_first_pct_chg_str, size=2.5, lineheight=1,
           hjust=0, colour="#777777"
  ) +
  scale_x_continuous(expand=c(0, 0), limits=c(0, 2)) +
  scale_y_continuous(expand=c(0, 0), limits=c(0, 2)) +
  labs(
    title=paste(comma(latest_7day_doses_first_sum), " first doses", sep=""),
    subtitle="administered to date", x="", y="", fill=""
  ) +
  minimal_theme() +
  theme(
    # text=element_text(family="Open Sans"),
    axis.title=element_blank(), axis.text=element_blank(),
    axis.line=element_blank(), axis.ticks=element_blank(),
    plot.margin=unit(c(0,0,1,0),"cm"),
    plot.title=ggplot2::element_text(size=16,margin=ggplot2::margin(0,0,0,0), colour="#000000"),
    plot.subtitle=ggplot2::element_text(size=10, margin=ggplot2::margin(0,0,.25,0), colour="#777777"),
    panel.grid.major.x=ggplot2::element_blank(), panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(), panel.grid.minor.y=ggplot2::element_blank()
  )

p_vaccinations_7day <- prepare_plot(p_vaccinations_7day)


################################################################################
# First doses per capita
################################################################################
p_first_doses_100K <- ggplot() +
  annotate(geom="text", x=0, y=1.4,
           label=paste(sprintf(" "), abs(round(latest_cumulative_first_doses_per_100K / 1000, digits=1)), "%", sep=""),
           size=6, fontface="bold", hjust=0
  ) +
  annotate(geom="text", x=0, y=.45,
           label=paste("of the eligible population  \nhas been immunized"), size=2.5, lineheight=1,
           hjust=0, colour="#777777"
  ) +

  scale_x_continuous(expand=c(0, 0), limits=c(0, 2)) +
  scale_y_continuous(expand=c(0, 0), limits=c(0, 2)) +
  labs(
    title=paste(comma(latest_cumulative_first_doses_per_100K), " first doses", sep=""),
    subtitle="administered per capita", x="", y="", fill=""
  ) +
  minimal_theme() +
  theme(
    # text=element_text(family="Open Sans"),
    axis.title=element_blank(), axis.text=element_blank(),
    axis.line=element_blank(), axis.ticks=element_blank(),
    plot.margin=unit(c(0,0,1,0),"cm"),
    plot.title=ggplot2::element_text(size=16,margin=ggplot2::margin(0,0,0,0), colour="#000000"),
    plot.subtitle=ggplot2::element_text(size=10, margin=ggplot2::margin(0,0,.25,0), colour="#777777"),
    panel.grid.major.x=ggplot2::element_blank(), panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(), panel.grid.minor.y=ggplot2::element_blank()
  )

p_first_doses_100K <- prepare_plot(p_first_doses_100K)


p_topline_stack <- ggarrange(
  p_cases_7day,
  p_deaths_7day,
  p_vaccinations_7day,
  p_first_doses_100K,
  labels=c("", "", ""),
  ncol=1, nrow=4
)

p_topline_cases_deaths_1st_doses_vertical <- plot_grid(
  p_title.p,
  p_topline_stack,
  p_credit.p,
  p_source.p,
  nrow=4,
  align="v"
) +
  theme(plot.margin=margin(0.2,0.2,0.2,0.2, "cm"))


ggsave_pngpdf(p_topline_cases_deaths_1st_doses_vertical, "p_topline_cases_deaths_1st_doses_vertical", width_var=2.38, height_var=2.62, dpi_var=300, scale_var=1, units_var="in")

