
covid19_Rt <- read_csv("data/raw/covid19_rt_MPEREIRA_WFP.csv") %>%
  clean_names()


max_date = max(covid19_Rt$date)

covid19_Rt_manitoba <- covid19_Rt %>%
  select(
    date,
    manitoba_rt,
    manitoba_low,
    manitoba_high
  ) %>%
  rename(
    "rt" = manitoba_rt,
    "low" = manitoba_low,
    "high" = manitoba_high
  ) %>%
  mutate(
    jurisdiction = "Manitoba"
  )

covid19_Rt_winnipeg <- covid19_Rt %>%
  select(
    date,
    winnipeg_rt,
    winnipeg_low,
    winnipeg_high
  ) %>%
  rename(
    "rt" = "winnipeg_rt",
    "low" = "winnipeg_low",
    "high" = "winnipeg_high"
  ) %>%
  mutate(
    jurisdiction = "Winnipeg"
  )

covid19_Rt_combined <- rbind(
  covid19_Rt_manitoba,
  covid19_Rt_winnipeg
) %>%
  mutate(
    jurisdiction = factor(jurisdiction, levels=c("Manitoba", "Winnipeg"))
  )

str(covid19_Rt_combined)



p_covid19_Rt_manitoba <- ggplot(covid19_Rt_manitoba) +
  aes(x = date, y = rt) +
  geom_ribbon(aes(ymin = low, ymax = high), fill = nominalMuted_shade_0, alpha=.5) +
  geom_line(aes(x = date, y = rt), colour=wfp_blue) +
  geom_text(data=covid19_Rt_manitoba %>% filter(date==max(date)),
            aes(label=paste(round(rt, digits=2), sep="")),
            hjust=-.08, size=4, fontface="bold"
            )+
  geom_text(data=covid19_Rt_manitoba %>% filter(date==max(date)),
            aes(label=paste("95% CI: ", round(low, digits=2), "-", round(high, digits=2),
                            sep="")),
            vjust=2.5, hjust=-.05, size=3.5
  )+
  scale_y_continuous(
    expand = c(0, 0),
    limits = c(0, 2)
  ) +
  scale_x_date(
    expand = c(0, 0),
    limits = c(as.Date("2020-09-01"), as.Date("2021-05-30")),
    date_breaks = "1 month",
    date_minor_breaks = "1 month",
    labels = date_format("%b")
  ) +
  minimal_theme() +
  labs(
    title = wrap_text("Effective reproductive number for COVID-19 in Manitoba", 70),
    subtitle = "",
    caption = wrap_text(paste(toupper("WINNIPEG FREE PRESS — SOURCE: RYAN IMGRUND"), " (", max_date, ")", sep=""), 120),
    x = "",
    y = "",
    colour = "",
    fill=""
  )

wfp_covid19_Rt_manitoba <- prepare_plot(p_covid19_Rt_manitoba)
ggsave_pngpdf(wfp_covid19_Rt_manitoba, "wfp_covid19_Rt_manitoba", width_var=8.66, height_var=6, dpi_var=96, scale_var=1, units_var="in")




p_covid19_Rt_winnipeg <- ggplot(covid19_Rt_winnipeg) +
  aes(x = date, y = rt) +
  geom_ribbon(aes(ymin = low, ymax = high), fill = nominalMuted_shade_0, alpha=.5) +
  geom_line(aes(x = date, y = rt), colour=wfp_blue) +
  geom_text(data=covid19_Rt_winnipeg %>% filter(date==max(date)),
            aes(label=paste(round(rt, digits=2), sep="")),
            hjust=-.08, size=4, fontface="bold"
  )+
  geom_text(data=covid19_Rt_winnipeg %>% filter(date==max(date)),
            aes(label=paste("95% CI: ", round(low, digits=2), "-", round(high, digits=2),
                            sep="")),
            vjust=2.5, hjust=-.05, size=3.5
  )+
  scale_y_continuous(
    expand = c(0, 0),
    limits = c(0, 2)
  ) +
  scale_x_date(
    expand = c(0, 0),
    limits = c(as.Date("2020-09-01"), as.Date("2021-05-30")),
    date_breaks = "1 month",
    date_minor_breaks = "1 month",
    labels = date_format("%b")
  ) +
  minimal_theme() +
  labs(
    title = wrap_text("Effective reproductive number for COVID-19 in Winnipeg", 70),
    subtitle = "",
    caption = wrap_text(paste(toupper("WINNIPEG FREE PRESS — SOURCE: RYAN IMGRUND"), " (", max_date, ")", sep=""), 120),
    x = "",
    y = "",
    colour = "",
    fill=""
  )

wfp_covid19_Rt_winnipeg <- prepare_plot(p_covid19_Rt_winnipeg)
ggsave_pngpdf(wfp_covid19_Rt_winnipeg, "wfp_covid19_Rt_winnipeg", width_var=8.66, height_var=6, dpi_var=96, scale_var=1, units_var="in")


