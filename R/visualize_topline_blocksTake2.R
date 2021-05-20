
font_add_google("Open Sans")
showtext_auto()

date_current=max(wfp_covid19_topline$date)
date_min_90days=date_current - 90
date_min_60days=date_current - 60
date_min_30days=date_current - 30
date_max=date_current
date_max_15 <- date_max + 15


latest_7day_cases_sum <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(cases_7day_sum) %>% pull()
latest_7day_cases_pct_chg <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(cases_7day_pctchg) %>% pull()

latest_7day_deaths_sum <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(deaths_7day_sum) %>% pull()
latest_7day_deaths_pct_chg <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(deaths_7day_pctchg) %>% pull()

latest_7day_doses_first_sum <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(doses_first_7day_sum) %>% pull()
latest_7day_doses_first_pct_chg <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(doses_first_7day_pctchg) %>% pull()


latest_cumulative_first_doses_per_100K <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(cumulative_first_doses_per_100K) %>% pull()


################################################################################
# Strings
################################################################################

p_title <- paste("COVID-19 in Manitoba")
p_title.p <- ggparagraph(text=p_title, face="bold", size=14, lineheight=1, color="black", margin(0,0.2,0,0.2, "cm"))

p_title_vaccinations <- paste("COVID-19 vaccinations in Manitoba")
p_title_vaccinations.p <- ggparagraph(text=p_title_vaccinations, face="bold", size=18, color="black", margin(0,0.2,0,0.2, "cm"))

p_credit=toupper(credit_str)
p_credit.p=ggparagraph(text=p_credit, size=7, color="black",  margin(0.2,0.2,0,0.2, "cm"))

p_source=toupper(paste("SOURCE: ", "Manitoba Health", " (", format(date_max, "%Y-%m-%d"), ")",sep=""))
p_source.p=ggparagraph(text=p_source, size=7, color="black",  margin(0.2,0.2,0,0.2, "cm"))

latest_7day_cases_pct_chg_str <- ""
latest_7day_cases_pct_chg_sym <- ""
if(latest_7day_cases_pct_chg > 0){
  latest_7day_cases_pct_chg_sym="\u25B2" #"▲"
  latest_7day_cases_pct_chg_str=paste("increase in cases compared \nto previous seven days", sep="")
}

if(latest_7day_cases_pct_chg < 0){
  latest_7day_cases_pct_chg_sym="▼" #"\u25BC"
  latest_7day_cases_pct_chg_str=paste("decrease in cases compared \nto previous seven days", sep="")
}

if(latest_7day_cases_pct_chg == 0){
  latest_7day_cases_pct_chg_sym="-" #"\u25BC"
  latest_7day_cases_pct_chg_str=paste("no change in cases compared \nto previous seven days", sep="")
}

latest_7day_deaths_pct_chg_sym=""
latest_7day_deaths_pct_chg_str=""
latest_7day_deaths_pct_chg_str <- ""
if(latest_7day_deaths_pct_chg > 0){
  latest_7day_deaths_pct_chg_sym="▲" #"\u25B2"
  latest_7day_deaths_pct_chg_str=paste("increase in deaths compared \nto previous seven days", sep="")
}

if(latest_7day_deaths_pct_chg < 0){
  latest_7day_deaths_pct_chg_sym="▼" #"\u25BC"
  latest_7day_deaths_pct_chg_str=paste("decrease in deaths compared \nto previous seven days", sep="")
}

if(latest_7day_deaths_pct_chg == 0){
  latest_7day_deaths_pct_chg_sym="-" #"\u25BC"
  latest_7day_deaths_pct_chg_str=paste("no change in deaths compared \nto previous seven days", sep="")
}

latest_7day_doses_first_pct_chg_sym=""
latest_7day_doses_first_pct_chg_str=""
if(latest_7day_doses_first_pct_chg > 0){
  latest_7day_doses_first_pct_chg_sym="▲" #"\u25B2"
  latest_7day_doses_first_pct_chg_str=paste("increase in first vaccine doses\n", sep="")
}

if(latest_7day_doses_first_pct_chg < 0){
  latest_7day_doses_first_pct_chg_sym="▼" #"\u25BC"
  latest_7day_doses_first_pct_chg_str=paste("decrease in first vaccine doses\n", sep="")
}

if(latest_7day_doses_first_pct_chg == 0){
  latest_7day_doses_first_pct_chg_sym="-" #"\u25BC"
  latest_7day_doses_first_pct_chg_str=paste("no change in first vaccine doses\n", sep="")
}

################################################################################
# 7 day cases
################################################################################
p_cases_7day <- ggplot() +
  annotate(geom="text", x=0, y=1.4,
           label=sprintf(latest_7day_cases_pct_chg_sym),
           size=6, fontface="bold", hjust=0
  ) +
  annotate(geom="text", x=.4, y=1.4,
           label=paste(abs(round(latest_7day_cases_pct_chg, digits=1)), "%", sep=""),
           size=6, fontface="bold", hjust=0
          ) +
  annotate(geom="text", x=0, y=.45,
           label=latest_7day_cases_pct_chg_str, size=2.5, lineheight=1,
           hjust=0, colour="#777777"
  ) +
  scale_x_continuous(expand=c(0, 0), limits=c(0, 2)) +
  scale_y_continuous(expand=c(0, 0), limits=c(0, 2)) +
  labs(
    title=paste(latest_7day_cases_sum, " new cases", sep=""),
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

p_cases_7day <- prepare_plot(p_cases_7day)


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


