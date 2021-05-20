
vaccine_compare <- covid_vaccine %>%
  mutate(
    province=ifelse(province == "BC", "British Columbia",
                ifelse(province == "NL", "Newfoundland and Labrador",
                 ifelse(province == "NWT", "Northwest Territories",
                  ifelse(province == "PEI", "Prince Edward Island",

                      province
                      ))))
  )

vaccine_compare <-  as.data.frame(vaccine_compare)
population_provinces_2020 <- as.data.frame(population_provinces_2020)

vaccine_compare_j_pop <- left_join(
  vaccine_compare,
  population_provinces_2020,
  by=c("province"="province")
) %>%
  mutate(
    administered_doses_per_capita=cumulative_avaccine / population * 100000,
    administration_gap_per_capita=dose_difference / population * 100000
  )



p_admin_gap_comparison <- ggplot(vaccine_compare_j_pop) +
  aes(x=date, y=administration_gap_per_capita) +
  geom_line(size=.5, colour=nominalMuted_shade_0) +
  geom_point(
    data=vaccine_compare_j_pop %>% filter(date==max(date)),
    aes(x=date, y=administration_gap_per_capita),
    size=.75, colour=wfp_blue) +

  geom_text(
    data=vaccine_compare_j_pop %>% filter(date==max(date)),
    aes(x=as.Date("2021-06-30"), y=85000,
        label= paste(
          comma(dose_difference), " unused doses",
          sep="")
    ),
    size=3, hjust=1, vjust=.1
  ) +
  geom_text(
    data=vaccine_compare_j_pop %>% filter(date==max(date)),
    aes(x=as.Date("2021-06-30"), y=65000,
        label= paste(
                     comma(round(administration_gap_per_capita, digits=2)), "/100K people",
                     sep="")
           ),
    size=3, hjust=1, vjust=.1
  ) +
  scale_x_date(
    limits=as.Date(c("2020-12-01","2021-06-30")),
    date_breaks="2 month",
    date_minor_breaks="1 month",
    labels=date_format("%b")
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 100000),
    breaks=seq(0,100000,by=25000)
  ) +
  labs(
    title="Unused COVID-19 vaccine doses per capita",
    caption=paste("WINNIPEG FREE PRESS — SOURCE: COVID-19 CANADA OPEN DATA WORKING GROUP (2021-04-08)", sep=""),
    x="",
    y=""
  ) +
  minimal_theme() +
  theme(
    strip.background=ggplot2::element_blank(),
    strip.text=ggplot2::element_text(size =10, hjust=0, face="bold"),
    panel.border=ggplot2::element_blank()
  ) +
  facet_wrap(~province, ncol=3)


wfp_admin_gap_comparison <- prepare_plot(p_admin_gap_comparison)
ggsave_pngpdf(wfp_admin_gap_comparison, "wfp_admin_gap_comparison", width_var=8.66, height_var=8.66, dpi_var=300, scale_var=1, units_var="in")
