library(readr)
last_update_timestamp=Sys.Date()


Manitoba_COVID_19_Vaccine_Uptake_by_District <- read_csv("data/raw/Manitoba_COVID-19_Vaccine_Uptake_by_District-1.csv") %>%
  clean_names() %>%
  select(-objectid) %>%
  mutate(
    rha = ifelse(rhacode == "SO", "Southern Health", rha),
    rha = factor(rha,
                 levels=c(
                   "Interlake-Eastern",
                   "Northern",
                   "Prairie Mountain Health",
                   "Southern Health",
                   "Winnipeg"
                 ))
  )


Manitoba_COVID_19_Vaccine_Uptake_by_District__1stdose_top20 <- Manitoba_COVID_19_Vaccine_Uptake_by_District %>%
  arrange(desc(uptake_1)) %>%
  head(20) %>%
  ggplot() +
  aes(x=reorder(rhadname, uptake_1), y=uptake_1, fill=rha) +
  geom_col(aes(x=reorder(rhadname, uptake_1), y=uptake_1, fill=rha)) +
  geom_text(
    aes(
        x=reorder(rhadname, uptake_1), y=uptake_1,
        fill=rha,
        label=paste(uptake_1)
    ),
    color="#000000", hjust=-.25, vjust=.25, size=4
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 100),
    # labels=scales::comma
    labels=function(x) {
      ifelse(x == 100, paste(x, "%", sep=""), x)
    }
  ) +
  scale_fill_brewer(palette = "Set2", drop=FALSE) +
  # scale_fill_manual(
  #   drop=FALSE,
  #   values=c(
  #     "Interlake-Eastern" = nominalBold_shade_0,
  #     "Northern" = nominalBold_shade_1,
  #     "Prairie Mountain Health" = nominalBold_shade_2,
  #     "Southern Health" = nominalBold_shade_3,
  #     "Winnipeg" = nominalBold_shade_4
  #   ),
  #   labels=c(
  #     "Interlake-Eastern",
  #     "Northern",
  #     "Prairie Mountain Health",
  #     "Southern Health",
  #     "Winnipeg"
  #   )
  # ) +
  coord_flip() +
  minimal_theme() +
  labs(
    title=wrap_text("Health districts with highest vaccination uptake", 65),
    subtitle=wrap_text("Percentage of eligible Manitobans with a a first dose of a COVID-19 vaccine", 80),
    caption=wrap_text(toupper(paste("WINNIPEG FREE PRESS — SOURCE: ", "MANITOBA HEALTH", " (", last_update_timestamp, ")",sep="")), 80),
    x="",
    y="",
    fill=""
  ) +
  theme(
    # axis.line=element_blank(),
    # axis.text.x=element_blank(),
    # axis.ticks=element_blank(),
    # axis.title.x=element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank(),
    legend.background = element_rect(fill="white", size=0.5, linetype="solid", colour ="white"),
    legend.title=ggplot2::element_text(face="bold"),
    legend.position=c(-.68, .99),
    legend.justification=c("right", "top"),
    legend.box.just="right",
    legend.margin=margin(1,5,1,5),
    legend.spacing.y = unit(.5, 'cm')
  )


wfp_covid_vaccine_uptake_1stdose_top20 <- prepare_plot(Manitoba_COVID_19_Vaccine_Uptake_by_District__1stdose_top20)
ggsave_pngpdf(wfp_covid_vaccine_uptake_1stdose_top20, "wfp_covid_vaccine_uptake_1stdose_top20", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")


Manitoba_COVID_19_Vaccine_Uptake_by_District__1stdose_bottom20 <- Manitoba_COVID_19_Vaccine_Uptake_by_District %>%
  arrange(uptake_1) %>%
  head(20) %>%
  ggplot() +
  aes(x=reorder(rhadname, uptake_1), y=uptake_1, fill=rha) +
  geom_col(aes(x=reorder(rhadname, uptake_1), y=uptake_1, fill=rha)) +
  geom_text(
    aes(
      x=reorder(rhadname, uptake_1), y=uptake_1,
      fill=rha,
      label=paste(uptake_1)
    ),
    color="#000000", hjust=-.25, vjust=.25, size=4
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 100),
    # labels=scales::comma
    labels=function(x) {
      ifelse(x == 100, paste(x, "%", sep=""), x)
    }
  ) +
  scale_fill_brewer(palette = "Set2", drop=FALSE) +
coord_flip() +
  minimal_theme() +
  labs(
    title=wrap_text("Health districts with lowest vaccination uptake", 65),
    subtitle=wrap_text("Percentage of eligible Manitobans with a a first dose of a COVID-19 vaccine", 80),
    caption=wrap_text(toupper(paste("WINNIPEG FREE PRESS — SOURCE: ", "MANITOBA HEALTH", " (", last_update_timestamp, ")",sep="")), 80),
    x="",
    y="",
    fill=""
  ) +
  theme(
    # axis.line=element_blank(),
    # axis.text.x=element_blank(),
    # axis.ticks=element_blank(),
    # axis.title.x=element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank(),
    legend.background = element_rect(fill="white", size=0.5, linetype="solid", colour ="white"),
    legend.title=ggplot2::element_text(face="bold"),
    legend.position=c(-.68, .4),
    legend.justification=c("right", "top"),
    legend.box.just="right",
    legend.margin=margin(1,5,1,5),
    legend.spacing.y = unit(.5, 'cm')
  )


wfp_covid_vaccine_uptake_1stdose_bottom20 <- prepare_plot(Manitoba_COVID_19_Vaccine_Uptake_by_District__1stdose_bottom20)
ggsave_pngpdf(wfp_covid_vaccine_uptake_1stdose_bottom20, "wfp_covid_vaccine_uptake_1stdose_bottom20", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

