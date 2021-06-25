
Manitoba_COVID_19_Vaccine_Uptake_by_District <- read_csv("data/raw/Manitoba_COVID-19_Vaccine_Uptake_by_District.csv") %>%
  clean_names() %>%
  select(-objectid, -shape_length, -shape_area) %>%
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


last_update <-  Manitoba_COVID_19_Vaccine_Uptake_by_District %>%
  head(1) %>%
  select(date) %>%
  pull()

last_updated_ts <- as.Date(last_update)

p_vaccine_uptake_dose_1 <- ggplot(Manitoba_COVID_19_Vaccine_Uptake_by_District) +
  aes(x=reorder(rhadname, uptake_1), fill = rha, y = uptake_1) +
  geom_bar(stat="identity") +
  geom_text(
    aes(x=reorder(rhadname, uptake_1), y=uptake_1,
      label=paste(uptake_1)),
    color="#000000", hjust=-.25, vjust=.25, size=4
  ) +
  coord_flip() +
  scale_fill_brewer(palette = "Set2", drop=FALSE) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 100),
    # labels=scales::comma
    labels=function(x) {
      ifelse(x == 100, paste(x, "%", sep=""), x)
    }
  ) +
  labs(
    title=wrap_text("Vaccine uptake across Manitoba health districts", 65),
    subtitle=wrap_text("Percentage of eligible Manitobans with a first dose of a COVID-19 vaccine", 80),
    caption=wrap_text(toupper(paste("WINNIPEG FREE PRESS — SOURCE: ", "MANITOBA HEALTH", " (", last_updated_ts, ")",sep="")), 80),
    x="",
    y="",
    fill="Health region"
  ) +
  theme_minimal()+
  theme(
    plot.margin=unit(c(.5,.8,0,.8),"cm"),
    plot.title=ggplot2::element_text(face="bold"),
    # axis.line=element_blank(),
    # axis.text.x=element_blank(),
    # axis.ticks=element_blank(),
    # axis.title.x=element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank(),
    legend.background = element_rect(fill="white", size=0.5, linetype="solid", colour ="white"),
    legend.title=ggplot2::element_text(face="bold"),
    legend.position=c(-.48, .9),
    legend.justification=c("right", "top"),
    # legend.box.just="right",
    # legend.margin=margin(1,5,1,5),
    # legend.spacing.y = unit(.5, 'cm')
  )


p_vaccine_uptake_dose_2 <- ggplot(Manitoba_COVID_19_Vaccine_Uptake_by_District) +
  aes(x=reorder(rhadname, uptake_2), fill = rha, y = uptake_2) +
  geom_bar(stat="identity") +
  geom_text(
    aes(x=reorder(rhadname, uptake_2), y=uptake_2,
        label=paste(uptake_2)),
    color="#000000", hjust=-.25, vjust=.25, size=4
  ) +
  coord_flip() +
  scale_fill_brewer(palette = "Set2", drop=FALSE) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 100),
    # labels=scales::comma
    labels=function(x) {
      ifelse(x == 100, paste(x, "%", sep=""), x)
    }
  ) +
  labs(
    title=wrap_text("Vaccine uptake across Manitoba health districts", 65),
    subtitle=wrap_text("Percentage of eligible Manitobans with a second dose of a COVID-19 vaccine", 80),
    caption=wrap_text(toupper(paste("WINNIPEG FREE PRESS — SOURCE: ", "MANITOBA HEALTH", " (", last_updated_ts, ")",sep="")), 80),
    x="",
    y="",
    fill="Health region"
  ) +
  theme_minimal()+
  theme(
    plot.margin=unit(c(.5,.8,0,.8),"cm"),
    plot.title=ggplot2::element_text(face="bold"),
    # axis.line=element_blank(),
    # axis.text.x=element_blank(),
    # axis.ticks=element_blank(),
    # axis.title.x=element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank(),
    legend.background = element_rect(fill="white", size=0.5, linetype="solid", colour ="white"),
    legend.title=ggplot2::element_text(face="bold"),
    legend.position=c(-.48, .9),
    legend.justification=c("right", "top"),
    # legend.box.just="right",
    # legend.margin=margin(1,5,1,5),
    # legend.spacing.y = unit(.5, 'cm')
  )


wfp_vaccine_uptake_dose_1 <- prepare_plot(p_vaccine_uptake_dose_1)
ggsave_pngpdf(wfp_vaccine_uptake_dose_1, "wfp_covid_vaccine_uptake_1stdose_all", width_var=8.66, height_var=21, dpi_var=300, scale_var=1, units_var="in")

wfp_vaccine_uptake_dose_2 <- prepare_plot(p_vaccine_uptake_dose_2)
ggsave_pngpdf(wfp_vaccine_uptake_dose_2, "wfp_covid_vaccine_uptake_2nddose_all", width_var=8.66, height_var=21, dpi_var=300, scale_var=1, units_var="in")
