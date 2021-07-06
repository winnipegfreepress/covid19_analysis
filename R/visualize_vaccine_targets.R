
mb_18_plus_population_2020estimate <- 1068553
mb_12_17_population_2020estimate <- 111322

mb_12plus_population_2020estimate <- mb_12_17_population_2020estimate + mb_18_plus_population_2020estimate

mb_12plus_population_2020estimate <- population_12plus_total


mb_12plus_population_2020estimate_25pct=mb_12plus_population_2020estimate * .25
mb_12plus_population_2020estimate_50pct=mb_12plus_population_2020estimate * .5
mb_12plus_population_2020estimate_70pct=mb_12plus_population_2020estimate * .7


phac_covid_vaccine_mb_current <- COVID19_MB_first_second_vaccine_dose %>%
  rename(
    date=vaccination_date
  ) %>%
  mutate(
    daily_doses_7dayavg_projected=first_doses,
    daily_doses_5K_projected=first_doses,
    daily_doses_10K_projected=10000,
    daily_doses_20K_projected=20000,
    cumsum_daily_doses_7dayavg_projected=0,
    cumsum_daily_doses_5K_projected=0,
    cumsum_daily_doses_10K_projected=0,
    cumsum_daily_doses_20K_projected=0
  )

phac_covid_vaccine_mb_current <- as.data.frame(phac_covid_vaccine_mb_current)

maxdate_COVID19_MB_first_second_vaccine_dose <- max(phac_covid_vaccine_mb_current$date)

phac_covid_vaccine_mb_current_last_date_row <- phac_covid_vaccine_mb_current %>% filter(date == max(date))



cnt_first_dose <- phac_covid_vaccine_mb_current_last_date_row$cumulative_first_doses
pct_first_dose <- phac_covid_vaccine_mb_current_last_date_row$cumulative_first_doses / mb_12plus_population_2020estimate * 100

cnt_second_dose <- phac_covid_vaccine_mb_current_last_date_row$cumulative_second_doses
pct_second_dose <- phac_covid_vaccine_mb_current_last_date_row$cumulative_second_doses / mb_12plus_population_2020estimate * 100

subtitle_str <- paste(
  "Manitoba has administered ", comma(cnt_first_dose),
  " first doses of the COVID-19 vaccines, partially immunizing ",
  round(pct_first_dose, digits=1), " per cent of the eligible population 12 or older. ",
  comma(cnt_second_dose), " second doses have been administered, fully immunizing ",
  format(pct_second_dose, digits=2),
  " per cent of the eligible population. ",
  sep=""
)


phac_covid_vaccine_7day_avg <- phac_covid_vaccine_mb_current %>%
  mutate(
    daily_7day_avg=round(roll_mean(first_doses, 7, na.rm=TRUE, fill=NA, align="right"))
  ) %>%
  arrange(date)

phac_covid_vaccine_7day_avg_doses <- phac_covid_vaccine_7day_avg %>%
  filter(date==max(date)) %>%
  select(daily_7day_avg) %>%
  pull()


# Projections DF
phac_covid_vaccine_mb_projected <- data.frame(
  date=seq(as.Date(maxdate_COVID19_MB_first_second_vaccine_dose + 1),
    as.Date("2021-12-31"),
    by="1 day"
  )
) %>%
  mutate(
    first_doses=0,
    second_doses=0,
    total_doses=0,
    cumulative_first_doses=0,
    cumulative_second_doses=0,
    cumulative_total_doses=0,
    daily_doses_7dayavg_projected=phac_covid_vaccine_7day_avg_doses,
    daily_doses_5K_projected=5000,
    daily_doses_10K_projected=10000,
    daily_doses_20K_projected=20000,
    cumsum_daily_doses_7dayavg_projected=0,
    cumsum_daily_doses_5K_projected=0,
    cumsum_daily_doses_10K_projected=0,
    cumsum_daily_doses_20K_projected=0
  )


phac_covid_vaccine_mb_projections <- rbind(
  phac_covid_vaccine_mb_current,
  phac_covid_vaccine_mb_projected
  ) %>%
  arrange(date) %>%
  mutate(
    daily_doses_10K_projected=ifelse(date > as.Date("2021-04-01"), 10000, daily_doses_5K_projected),
    daily_doses_20K_projected=ifelse(date > as.Date("2021-04-01"), 20000, daily_doses_5K_projected)
  ) %>%
  mutate(
    cumsum_daily_doses_7dayavg_projected=cumsum(daily_doses_7dayavg_projected),
    cumsum_daily_doses_5K_projected=cumsum(daily_doses_5K_projected),
    cumsum_daily_doses_10K_projected=cumsum(daily_doses_10K_projected),
    cumsum_daily_doses_20K_projected=cumsum(daily_doses_20K_projected)
  )


p_vaccine_targets <- ggplot(phac_covid_vaccine_mb_projections) +
  geom_ribbon(
    data=phac_covid_vaccine_mb_projections %>% filter(date <= maxdate_COVID19_MB_first_second_vaccine_dose),
    aes(x=date, ymin=0, ymax=cumulative_first_doses),
    fill=wfp_blue, alpha=1) +

  ############################################################
  # Annotations for target dates
  ############################################################
  # annotate("segment",
  #          x=as.Date("2021-05-21"),
  #          y=0,
  #          xend=as.Date("2021-05-21"),
  #          yend=1000000,
  #          size=.5,
  #          alpha= .65,
  #          linetype="dotted",
  #          colour=nominalMuted_shade_1
  # ) +
  # geom_point(
  #   aes(x=as.Date("2021-05-21"), y=mb_12plus_population_2020estimate * .7),
  #   stat="identity",
  #   size=1,
  #   colour=nominalBold_shade_1,
  #   fill=nominalBold_shade_1
  # ) +
  #
  # annotate("text",
  #          x=as.Date("2021-06-03"),
  #          y=mb_12plus_population_2020estimate * .8,
  #          label=wrap_text("Provincial estimates for completion based on vaccine supply", 25),
  #          size=3.5,
  #          lineheight=1,
  #
  #          colour="#222222"
  # ) +
  #
  # annotate("text",
  #          x=as.Date("2021-05-21"),
  #          y=mb_12plus_population_2020estimate * .65,
  #          label=wrap_text("High supply", 20),
  #          hjust=1.1, vjust=0, size=3.5,
  #          lineheight=1,
  #
  #          colour="#222222"
  # ) +
  # annotate("segment",
  #          x=as.Date("2021-06-18"),
  #          y=0,
  #          xend=as.Date("2021-06-18"),
  #          yend=1000000,
  #          size=.5,
  #          alpha= .65,
  #          linetype="dotted",
  #          colour=nominalMuted_shade_1
  # ) +
  # geom_point(
  #   aes(x=as.Date("2021-06-18"), y=mb_12plus_population_2020estimate * .7),
  #   stat="identity",
  #   size=1,
  #   colour=nominalBold_shade_1,
  #   fill=nominalBold_shade_1
  # ) +
  # annotate("text",
  #          x=as.Date("2021-06-18"),
  #          y=mb_12plus_population_2020estimate * .65,
  #          label=wrap_text("Low supply", 20),
  #          hjust=-.1, vjust=0, size=3.5,
  #          lineheight=1,
  #          colour="#222222"
  # ) +
  #
  # geom_point(
  #   aes(x=as.Date(maxdate_COVID19_MB_first_second_vaccine_dose), y=cnt_first_dose,),
  #   stat="identity",
  #   size=.75,
  #   colour=wfp_blue,
  #   fill=wfp_blue
  # ) +

  annotate("text",
         x=as.Date(maxdate_COVID19_MB_first_second_vaccine_dose),
         y=cnt_first_dose,
         label=wrap_text(paste(round(pct_first_dose, digits=1), "% of eligible population", sep=""), 40),
         hjust=1, vjust=-2.5, size=4,
         lineheight=1,
         fontface="bold",
         colour="#222222"
  ) +
  annotate("text",
           x=as.Date(maxdate_COVID19_MB_first_second_vaccine_dose),
           y=cnt_first_dose,
           label=wrap_text(paste(comma(cnt_first_dose), " first doses", sep=""), 20),
           hjust=1, vjust=-1, size=3.5,
           lineheight=1,
           colour="#222222"
  ) +
  scale_x_date(
    expand=c(0, 0),
    limits=as.Date(c("2020-12-01", "2021-08-30")),
    date_breaks="1 month",
    labels=date_format("%b")
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 2000000),
    labels=comma
  ) +
  labs(
    title=wrap_text("COVID-19 vaccinations in Manitoba", 65),
    subtitle=wrap_text(subtitle_str, 88),
    caption=

      paste("Vaccination percentages may differ from provincial estimates due to discrepancies in population projections and official vaccination counts.",
            "\n",
            toupper("Winnipeg Free Press"), " — SOURCE: ", toupper("Manitoba Health Vaccine Dashboard"), " (", last_update_timestamp, ")", sep="")

    ,
    x="",
    y="",
    fill=""
  ) +
  minimal_theme()




p_vaccine_targets_5_10_20K <- p_vaccine_targets +
  annotate("text",
           x=as.Date("2020-12-15"),
           y=mb_12plus_population_2020estimate,
           label=paste("Projected population (18+)", sep=""),
           hjust=0, vjust=-.75, size=3.5,
           colour="#222222"
  ) +
  annotate("text",
           x=as.Date("2020-12-15"),
           y=mb_12plus_population_2020estimate * .7,
           label=paste("Vaccination target: 70% of eligible Manitobans", sep=""),
           hjust=0, vjust=-.75, size=3.5,
           colour="#222222"
  ) +
  # geom_line(
  #   data=phac_covid_vaccine_mb_projections %>%
  #     filter(date >= maxdate_COVID19_MB_first_second_vaccine_dose) %>%
  #     filter(cumsum_daily_doses_20K_projected <= 1200000),
  #   aes(x=date, y=cumsum_daily_doses_20K_projected),
  #   stat="identity",
  #   size=.5,
  #   alpha=.5,
  #   linetype="dotted",
  #   colour=nominalMuted_shade_3
  # ) +
  # geom_line(
  #   data=phac_covid_vaccine_mb_projections %>%
  #     filter(date >= maxdate_COVID19_MB_first_second_vaccine_dose) %>%
  #     filter(cumsum_daily_doses_10K_projected <= 1200000),
  #   aes(x=date, y=cumsum_daily_doses_10K_projected),
  #   stat="identity",
  #   size=.5,
  #   alpha=.5,
  #   linetype="dotted",
  #   colour=nominalMuted_shade_2
  # ) +
  # geom_line(
  #   data=phac_covid_vaccine_mb_projections %>%
  #     filter(date >= maxdate_COVID19_MB_first_second_vaccine_dose) %>%
  #     filter(cumsum_daily_doses_5K_projected <= 1200000),
  #   aes(x=date, y=cumsum_daily_doses_5K_projected),
  #   stat="identity",
  #   size=.5,
  #   alpha=.5,
  #   linetype="dotted",
  #   colour=nominalMuted_shade_1
  # ) +
  geom_text(
    data=phac_covid_vaccine_mb_projections %>%
      filter(cumsum_daily_doses_20K_projected >= 350000) %>%
      head(1),
    aes(x=date,
        y=cumsum_daily_doses_20K_projected,
        label=wrap_text("20K/day", 10)
    ),
    size=3, lineheight=1, colour="#777777"
  ) +
  geom_text(
    data=phac_covid_vaccine_mb_projections %>%
      filter(cumsum_daily_doses_10K_projected >= 425000) %>%
      head(1),
    aes(x=date,
        y=cumsum_daily_doses_10K_projected,
        label=wrap_text("10K/day", 10)
    ),
    size=3, lineheight=1, colour="#777777"
  ) +
  geom_text(
    data=phac_covid_vaccine_mb_projections %>%
      filter(cumsum_daily_doses_5K_projected >= 320000) %>%
      head(1),
    aes(x=date,
        y=cumsum_daily_doses_5K_projected,
        label=wrap_text("5K/day", 10)
    ),
    size=3, lineheight=1, colour="#777777"
  )


p_vaccine_targets_7dayavg <- p_vaccine_targets
  # geom_line(
  #   data=phac_covid_vaccine_mb_projections %>%
  #     filter(date >= maxdate_COVID19_MB_first_second_vaccine_dose),
  #   aes(x=date, y=cumsum_daily_doses_7dayavg_projected),
  #   stat="identity",
  #   size=.75,
  #   alpha=1,
  #   linetype="dotted",
  #   colour=wfp_blue
  # )
  # geom_point(
  #   data=phac_covid_vaccine_mb_projections %>%
  #     filter(cumsum_daily_doses_7dayavg_projected > mb_12plus_population_2020estimate_25pct - phac_covid_vaccine_7day_avg_doses) %>%
  #     filter(cumsum_daily_doses_7dayavg_projected < mb_12plus_population_2020estimate_25pct + phac_covid_vaccine_7day_avg_doses) %>%
  #     head(1)
  #   ,
  #   aes(x=date, y=cumsum_daily_doses_7dayavg_projected),
  #   stat="identity",
  #   size=2,
  #   shape=21,
  #   colour=nominalBold_shade_1,
  #   fill=nominalBold_shade_1
  # ) +
  # geom_text(
  #   data=phac_covid_vaccine_mb_projections %>%
  #     filter(cumsum_daily_doses_7dayavg_projected > mb_12plus_population_2020estimate_25pct - phac_covid_vaccine_7day_avg_doses) %>%
  #     filter(cumsum_daily_doses_7dayavg_projected < mb_12plus_population_2020estimate_25pct + phac_covid_vaccine_7day_avg_doses) %>%
  #     head(1)
  #   ,
  #   aes(x=date, y=cumsum_daily_doses_7dayavg_projected, label="25%"),
  #   stat="identity",
  #   size=3,
  #   vjust=-1
  # ) +

  # geom_point(
  #   data=phac_covid_vaccine_mb_projections %>%
  #     filter(cumsum_daily_doses_7dayavg_projected > mb_12plus_population_2020estimate_50pct - phac_covid_vaccine_7day_avg_doses) %>%
  #     filter(cumsum_daily_doses_7dayavg_projected < mb_12plus_population_2020estimate_50pct + phac_covid_vaccine_7day_avg_doses) %>%
  #     head(1)
  #   ,
  #   aes(x=date, y=cumsum_daily_doses_7dayavg_projected),
  #   stat="identity",
  #   size=2,
  #   shape=21,
  #   colour=nominalBold_shade_1,
  #   fill=nominalBold_shade_1
  # ) +
  # geom_text(
  #   data=phac_covid_vaccine_mb_projections %>%
  #     filter(cumsum_daily_doses_7dayavg_projected > mb_12plus_population_2020estimate_50pct - phac_covid_vaccine_7day_avg_doses) %>%
  #     filter(cumsum_daily_doses_7dayavg_projected < mb_12plus_population_2020estimate_50pct + phac_covid_vaccine_7day_avg_doses) %>%
  #     head(1)
  #   ,
  #   aes(x=date, y=cumsum_daily_doses_7dayavg_projected, label="50%"),
  #   stat="identity",
  #   size=3,
  #   vjust=-1
  # ) +

#
#   geom_point(
#     data=phac_covid_vaccine_mb_projections %>%
#       filter(cumsum_daily_doses_7dayavg_projected > mb_12plus_population_2020estimate_70pct - phac_covid_vaccine_7day_avg_doses) %>%
#       filter(cumsum_daily_doses_7dayavg_projected < mb_12plus_population_2020estimate_70pct + phac_covid_vaccine_7day_avg_doses) %>%
#       head(1)
#     ,
#     aes(x=date, y=cumsum_daily_doses_7dayavg_projected),
#     stat="identity",
#     size=2,
#     shape=21,
#     colour=nominalBold_shade_1,
#     fill=nominalBold_shade_1
#   ) +
#   geom_text(
#     data=phac_covid_vaccine_mb_projections %>%
#       filter(cumsum_daily_doses_7dayavg_projected > mb_12plus_population_2020estimate_70pct - phac_covid_vaccine_7day_avg_doses) %>%
#       filter(cumsum_daily_doses_7dayavg_projected < mb_12plus_population_2020estimate_70pct + phac_covid_vaccine_7day_avg_doses) %>%
#       head(1)
#     ,
#     aes(x=date, y=cumsum_daily_doses_7dayavg_projected + 20000,
#         label=wrap_text("70%", 20)
#         ),
#     stat="identity",
#     fontface="bold",
#     size=4,
#     vjust=-.5
#   ) +
  # annotate("text",
  #          x=as.Date(maxdate_COVID19_MB_first_second_vaccine_dose + 1),
  #          y=cnt_first_dose + 130000,
  #          label=wrap_text(paste(comma(phac_covid_vaccine_7day_avg_doses), "daily doses", sep=" "), 50),
  #          hjust=-.44, vjust=.25, size=4,
  #          fontface="bold",
  #          lineheight=1,
  #          colour="#222222"
  # ) +
  # annotate("text",
  #          x=as.Date(maxdate_COVID19_MB_first_second_vaccine_dose + 1),
  #          y=cnt_first_dose + 130000,
  #          label=wrap_text(paste("Seven-day average", sep=" "), 50),
  #          hjust=-.45, vjust=2, size=3.5,
  #          lineheight=1,
  #          colour="#222222"
  # )

p_vaccine_targets <- p_vaccine_targets +
  annotate("text",
           x=as.Date("2020-12-15"),
           y=mb_12plus_population_2020estimate,
           label=paste("Projected population (18+)", sep=""),
           hjust=0, vjust=-.75, size=3.5,
           colour="#222222"
  ) +
  annotate("text",
           x=as.Date("2020-12-15"),
           y=mb_12plus_population_2020estimate * .7,
           label=paste("Vaccination target: 70% of eligible Manitobans", sep=""),
           hjust=0, vjust=-.75, size=3.5,
           colour="#222222"
  )

wfp_vaccine_targets <- prepare_plot(p_vaccine_targets)
ggsave_pngpdf(wfp_vaccine_targets, "wfp_vaccine_targets", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")


wfp_vaccine_targets_7dayavg <- prepare_plot(p_vaccine_targets_7dayavg)
ggsave_pngpdf(wfp_vaccine_targets_7dayavg, "wfp_vaccine_targets_7dayavg", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

wfp_vaccine_targets_5_10_20K <- prepare_plot(p_vaccine_targets_5_10_20K)
ggsave_pngpdf(wfp_vaccine_targets_5_10_20K, "wfp_vaccine_targets_5_10_20K", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
