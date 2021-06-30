
mean_district_total_cases_100K <-  mean(covid19_districts_cases_vax$district_total_cases_100K, na.rm=TRUE)
median_district_total_cases_100K <-  median(covid19_districts_cases_vax$district_total_cases_100K, na.rm=TRUE)

# This is 14 days hard-coded to June 16, 2021.
# Adjust and pull from zipped cache before rerunning.

p_covid19_districts_cases_vax_uptake1 <- ggplot(covid19_districts_cases_vax) +
  aes(x = uptake_1, y = district_total_cases_100K) +
  annotate("text",
           x=54,
           y=29000,
           label=wrap_text("55% vaccine uptake", 20),
           hjust=1, vjust=.5, lineheight=1.1,
           size=3.5,
           colour="#555555"
  ) +
  annotate("segment",
           x=55,
           y=30000,
           xend=55,
           yend=0,
           size=.25,
           alpha= 1,
           linetype="dotted",
           colour="#555555"
  ) +

  annotate("text",
           x=18,
           y=mean_district_total_cases_100K,
           label=paste("Average case rate", sep=""),
           hjust=1, vjust=-.5, lineheight=1.1,
           size=3.5,
           colour="#555555"
  ) +
  annotate("segment",
           x=0,
           y=mean_district_total_cases_100K,
           xend=100,
           yend=mean_district_total_cases_100K,
           size=.25,
           alpha= 1,
           linetype="dashed",
           colour="#555555"
  ) +


  geom_point(size = 2, colour = wfp_blue, fill = wfp_blue, alpha = .2, shape = 21) +
  geom_point(data = covid19_districts_cases_vax %>% filter(uptake_1 <= 55), size = 2, colour = "#ffffff", fill = wfp_blue, alpha = 1, shape = 21) +
  geom_text_repel(
    data = covid19_districts_cases_vax %>% filter(uptake_1 <= 55),
    aes(x = uptake_1, y = district_total_cases_100K, label = area_name),
    color = "#222222",
    size = 3.5,
    hjust = -.25,
    # vjust=-.25,
    direction = "both",
    segment.color = "#555555",
    segment.size = .25,
    show.legend = FALSE
  ) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, 100), labels = function(x) {
    ifelse(x == 100, paste(x, "%", sep = ""), x)
  }) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 30000), labels = comma) +
  labs(
    title = wrap_text("Vaccine uptake and total COVID-19 cases per 100,000 by district", 90),
    subtitle = wrap_text("Percentage of eligible population with a first dose", 90),
    caption = wrap_text(paste(toupper("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH"), " (", last_update_timestamp, ")", sep = ""), 120), x = "",
    x = "",
    y = "Total cases per 100,000 people",
    colour = "",
    fill = ""
  ) +
  minimal_theme() +
  # coord_flip() +
  theme(
    axis.title.x = ggplot2::element_text(face = "bold", size = 10, color = "#222222"),
    axis.text.x = ggplot2::element_text(size = 10, color = "#222222"),
  )


wfp_covid19_districts_cases_vax_uptake1 <- prepare_plot(p_covid19_districts_cases_vax_uptake1)
ggsave_pngpdf(wfp_covid19_districts_cases_vax_uptake1, "wfp_covid19_districts_cases_vax_uptake1", width_var = 8.66, height_var = 6, dpi_var = 150, scale_var = 1, units_var = "in")


# 14 day cases by district
################################################################################
# Daily snapshot of health district-level daily cases, active, recovered, death.
################################################################################
dashboard_daily_status_districts_all_current <- jsonlite::fromJSON(dir_data_raw("dashboard_daily_status_districts_all.json"))
dashboard_daily_status_districts_all_current <- dashboard_daily_status_districts_all_current[["features"]][["attributes"]]
dashboard_daily_status_districts_all_current <- dashboard_daily_status_districts_all_current %>%
  clean_names() %>%
  mutate( date = as.Date(as.POSIXct(as.integer(as.numeric(as.character(date)) / 1000.0), origin = "1970-01-01", tz = "GMT")) ) %>%
  filter( rha != area_name ) %>%
  left_join( manitoba_health_districts_populations, by = c("area_name" = "district", "rha" = "rha") ) %>%
  mutate( district_total_cases_100K = total_cases / pop_2019 * 100000, district_active_cases_100K = active_cases / pop_2019 * 100000 ) %>%
  filter( area_name %notin% c( "Interlake-Eastern", "Northern", "Prairie Mountain Health", "Southern Health-Santé Sud", "Southern Health-Santé Sud", "Winnipeg" ) ) %>%
  select(
    rha,
    area,
    area_name,
    total_cases,
    pop_2019
  ) %>%
  rename(
    total_cases_current = total_cases
  )


dashboard_daily_status_districts_all_14days <- jsonlite::fromJSON(dir_data_raw("dashboard_daily_status_districts_all-20210616.json"))
dashboard_daily_status_districts_all_14days <- dashboard_daily_status_districts_all_14days[["features"]][["attributes"]]
dashboard_daily_status_districts_all_14days <- dashboard_daily_status_districts_all_14days %>%
  clean_names() %>%
  mutate(date = as.Date(as.POSIXct(as.integer(as.numeric(as.character(date)) / 1000.0), origin = "1970-01-01", tz = "GMT"))) %>%
  filter(rha != area_name) %>%
  left_join(manitoba_health_districts_populations, by = c("area_name" = "district", "rha" = "rha")) %>%
  mutate(district_total_cases_100K = total_cases / pop_2019 * 100000, district_active_cases_100K = active_cases / pop_2019 * 100000) %>%
  filter(area_name %notin% c("Interlake-Eastern", "Northern", "Prairie Mountain Health", "Southern Health-Santé Sud", "Southern Health-Santé Sud", "Winnipeg")) %>%
  select(
    rha,
    area,
    area_name,
    total_cases,
    pop_2019
  ) %>%
  rename(
    total_cases_14days = total_cases
  )


dashboard_daily_status_districts_all_14day_new_cases <- left_join(
    dashboard_daily_status_districts_all_current,
    dashboard_daily_status_districts_all_14days,
    by=c("area_name"="area_name", "area"="area")
  ) %>%
  rename(
    rha = rha.x,
    pop_2019 = pop_2019.x
  ) %>%
  select(
    -rha.y,
    -pop_2019.y
  ) %>%
  mutate(
    new_case_14days = total_cases_current - total_cases_14days,
    new_case_14days_rate = new_case_14days / pop_2019 * 100000
  ) %>%
  left_join(
  covid19_districts_cases_vax %>% select(
    rha.x, area, area_name, total_cases, active_cases, deaths,
    pop_2019, district_total_cases_100K,
    uptake_1, uptake_2
  ),
  by=c("rha"="rha.x", "area"="area")
) %>%
  rename(
    area_name = area_name.x,
    pop_2019 = pop_2019.x
  ) %>%
  select(
    rha,
    area,
    area_name,
    area_name.y,
    pop_2019,
    pop_2019.y,
    total_cases,
    total_cases_current,
    total_cases_14days,
    new_case_14days,
    active_cases,
    new_case_14days_rate,
    deaths,
    district_total_cases_100K,
    uptake_1,
    uptake_2
  ) %>%
  mutate(
    vax_pct_uptake_1 = case_when(
      uptake_1 > 95 ~ "95-100",
      uptake_1 > 90 ~ "90-95",
      uptake_1 > 85 ~ "85-90",
      uptake_1 > 80 ~ "80-85",
      uptake_1 > 75 ~ "75-80",
      uptake_1 > 70 ~ "70-75",
      uptake_1 > 65 ~ "65-70",
      uptake_1 > 60 ~ "60-65",
      uptake_1 > 55 ~ "55-60",
      uptake_1 > 50 ~ "50-55",
      uptake_1 > 45 ~ "45-50",
      uptake_1 > 40 ~ "40-45",
      uptake_1 > 35 ~ "35-40",
      uptake_1 > 30 ~ "30-35",
      uptake_1 > 25 ~ "25-30",
      uptake_1 > 20 ~ "20-25",
      uptake_1 > 15 ~ "15-20",
      uptake_1 > 10 ~ "10-15",
      uptake_1 > 5 ~ "5-10",
      uptake_1 > 0 ~ "0-5",
      TRUE ~ as.character(uptake_1)
    )
  )


dashboard_daily_status_districts_all_14day_new_cases_grouped <- dashboard_daily_status_districts_all_14day_new_cases %>%
  group_by(vax_pct_uptake_1) %>%
  summarise(
    mean_14day_new_case_rate = mean(new_case_14days_rate, na.rm=TRUE),
    median_14day_new_case_rate = median(new_case_14days_rate, na.rm=TRUE)
  ) %>%
  ungroup()


p_avg_14day_new_100K <- ggplot(dashboard_daily_status_districts_all_14day_new_cases_grouped) +
  aes(x = vax_pct_uptake_1, weight = mean_14day_new_case_rate) +
  geom_bar(fill = wfp_blue) +
  geom_text(
    aes(x = vax_pct_uptake_1, y = mean_14day_new_case_rate,
        label=paste(round(mean_14day_new_case_rate, digits=0), sep=" ")),
    color = "#222222",
    size = 3.5,
    hjust = -.25,
    # vjust=-.25,
    direction = "both",
    segment.color = "#555555",
    segment.size = .25,
    show.legend = FALSE
  ) +
  coord_flip() +
  # scale_x_continuous(expand = c(0, 0), limits = c(0, 100), labels = function(x) {
  #   ifelse(x == 100, paste(x, "%", sep = ""), x)
  # }) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 300), labels = comma) +
  labs(
    title = wrap_text("New COVID-19 cases by health district vaccination uptake", 90),
    subtitle = wrap_text("Average new cases over previous two weeks per 100,000 people", 90),
    caption = wrap_text(paste(toupper("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH"), " (", last_update_timestamp, ")", sep = ""), 120), x = "",
    x = "",
    y = "",
    colour = "",
    fill = ""
  ) +
  minimal_theme() +
  theme(
    legend.title=element_blank(),
    legend.position="bottom",
    panel.grid.major.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank()

  )


wfp_avg_14day_new_100K <- prepare_plot(p_avg_14day_new_100K)
ggsave_pngpdf(wfp_avg_14day_new_100K, "wfp_avg_14day_new_100K", width_var = 8.66, height_var = 6, dpi_var = 150, scale_var = 1, units_var = "in")



p_avg_14day_new_100K_median <- ggplot(dashboard_daily_status_districts_all_14day_new_cases_grouped) +
  aes(x = vax_pct_uptake_1, weight = median_14day_new_case_rate) +
  geom_bar(fill = wfp_blue) +
  geom_text(
    aes(x = vax_pct_uptake_1, y = median_14day_new_case_rate,
        label=paste(round(median_14day_new_case_rate, digits=0), sep=" ")),
    color = "#222222",
    size = 3.5,
    hjust = -.25,
    # vjust=-.25,
    direction = "both",
    segment.color = "#555555",
    segment.size = .25,
    show.legend = FALSE
  ) +
  coord_flip() +
  # scale_x_continuous(expand = c(0, 0), limits = c(0, 100), labels = function(x) {
  #   ifelse(x == 100, paste(x, "%", sep = ""), x)
  # }) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 300), labels = comma) +
  labs(
    title = wrap_text("New COVID-19 cases by health district vaccination uptake", 90),
    subtitle = wrap_text("Median new cases over previous two weeks per 100,000 people", 90),
    caption = wrap_text(paste(toupper("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH"), " (", last_update_timestamp, ")", sep = ""), 120), x = "",
    x = "",
    y = "",
    colour = "",
    fill = ""
  ) +
  minimal_theme() +
  theme(
    legend.title=element_blank(),
    legend.position="bottom",
    panel.grid.major.x=ggplot2::element_blank(),
    panel.grid.major.y=ggplot2::element_blank(),
    panel.grid.minor.x=ggplot2::element_blank(),
    panel.grid.minor.y=ggplot2::element_blank()

  )


wfp_avg_14day_new_100K_median <- prepare_plot(p_avg_14day_new_100K_median)
ggsave_pngpdf(wfp_avg_14day_new_100K_median, "wfp_avg_14day_new_100K_median", width_var = 8.66, height_var = 6, dpi_var = 150, scale_var = 1, units_var = "in")

