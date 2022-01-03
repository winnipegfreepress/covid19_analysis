
phac_14daynew_provinces_rates <- phac_daily %>%
  filter(date==max(date)) %>%
  filter(!is.na(population)) %>%
  select(
    province,
    numtotal_last14,
    population
  ) %>%
  mutate(
    numtotal_last14=ifelse(is.na(numtotal_last14), 0, numtotal_last14),
    new_cases_last14_rate=(numtotal_last14/population) * 100000
  )



p_14daynew_provinces_rates <- plot_bar_x_reordered_y(
  phac_14daynew_provinces_rates %>% filter(province !="Canada"),
  x_var=province, y_var=new_cases_last14_rate,
  bar_colour=nominalMuted_shade_0,
  title_str="New COVID-19 cases in the previous 14 days per 100,000 people",
  subtitle_str="All reported cases", x_str="", y_str="",
  y_units="", ymin=0, ymax=1500,
  source_str="Public Health Agency of Canada", lastupdate_str=last_update_timestamp
)

p_14daynew_provinces_rates <- p_14daynew_provinces_rates +
  geom_bar(data=phac_14daynew_provinces_rates %>% filter(province=="Manitoba") %>% filter(province !="Canada"),
    aes(x=reorder(province, new_cases_last14_rate), y=new_cases_last14_rate),
    fill=wfp_blue,
    colour=wfp_blue,
    stat="identity"
  ) +
  geom_text(
    data=phac_14daynew_provinces_rates %>% filter(province !="Canada"),
    aes(
      label=
        ifelse(new_cases_last14_rate==0, 0, format(as.numeric(new_cases_last14_rate), digits=0))
    ),
    size=4, hjust=-.15, vjust=.4,
    position="identity",
    color="#222222"
  )

wfp_14daynew_provinces_rates <- prepare_plot(p_14daynew_provinces_rates)
ggsave_pngpdf(wfp_14daynew_provinces_rates, "wfp_14daynew_provinces_rates", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

