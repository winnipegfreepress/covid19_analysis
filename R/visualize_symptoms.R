
week_of_date <- wfp_symptoms_tall %>%  filter(week_of == max(week_of)) %>% select(week_of) %>% head(1) %>% pull()
as_of_date_str <- week_of_date + 6
as_of_date_str <- format(as_of_date_str, format="%B %d, %Y")


p_covid19_symptoms <- ggplot(wfp_symptoms_tall %>% filter(symptom %in% c("Symptomatic", "Asymptomatic"))) +
  aes(x=week_of, y=count, colour=factor(symptom), group=symptom) +
  geom_line(aes(x=week_of, y=count, colour=factor(symptom), group=symptom),
            size=1,
            alpha=.6) +
  geom_point(
    aes(x=week_of, y=count, colour=factor(symptom), fill=factor(symptom), group=symptom),
    size=.75,
    shape=21,
    alpha=1) +
  geom_point(
    data=wfp_symptoms_tall %>%  filter(week_of == max(week_of)) %>% filter(symptom %in% c("Symptomatic", "Asymptomatic")),
    aes(x=week_of, y=count, colour=factor(symptom), fill=factor(symptom), group=symptom),
    size=1.25,
    shape=21,
    alpha=1) +
  geom_text(data=wfp_symptoms_tall %>% filter(symptom %in% c("Symptomatic", "Asymptomatic")) %>%  filter(week_of == max(week_of)),
    aes(x=week_of + 4, y=count,
        label=paste(symptom, ": ", count, "%", sep="")
    ),
    color="#222222",
    size=4,
    hjust=0,
    vjust=.5,
    direction="y",
    segment.color="#999999",
    segment.size=.2,
    show.legend=FALSE
  ) +
  geom_point(data=wfp_symptoms_tall %>% filter(symptom %in% c("Symptomatic", "Asymptomatic")) %>%  filter(week_of == max(week_of)),
             aes(x=week_of, y=count, colour=factor(symptom), fill=factor(symptom), group=symptom),
             size=1.25,
             shape=21,
             alpha=1) +
  scale_colour_manual(
    values=c(
      "Symptomatic" = nominalBold_shade_0,
      "Asymptomatic" = nominalBold_shade_1
    ),
    guide=FALSE
  ) +
  scale_fill_manual(
    values=c(
      "Symptomatic" = nominalBold_shade_0,
      "Asymptomatic" = nominalBold_shade_1
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
    limits=c(as.Date("2020-05-01"), as.Date("2021-07-30")),
    date_breaks="1 month",
    date_minor_breaks="1 month",
    labels=date_format("%b")
  ) +
  labs(
    title=wrap_text("Percentage of reported symptomatic COVID-19 cases", 55),
    subtitle=paste("As of", as_of_date_str, sep=" "),
    caption=wrap_text(paste(
      toupper("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH (Provincial COVID-19 Surveillance Report)"), sep=""), 120),
    x="",
    y="",
    colour=""
  ) +
  minimal_theme()



wfp_covid19_symptoms <- prepare_plot(p_covid19_symptoms)
ggsave_pngpdf(wfp_covid19_symptoms, "wfp_covid19_symptoms", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")


