dashboard_demographics <- read_csv(dir_data_out("demographics_df.csv"))

dashboard_demographics_weekly_ages <-  dashboard_demographics %>%
  filter(rha == "All") %>%
  filter(date >= as.Date("2021-01-01")) %>%
  pivot_wider(
    names_from = gender,
    values_from = value
  ) %>%
  select(-rha) %>%
  mutate(
    epi_week = epiweek(date),
    epi_year = epiyear(date),
    total_cases_mf = rowSums(dplyr::across(ends_with("male")), na.rm = T)
  ) %>%
  select(date, epi_week, epi_year, age_group, total_cases_mf) %>%
  pivot_wider(
    names_from = age_group,
    values_from = total_cases_mf,
    names_prefix = "age_"
  ) %>%
  clean_names() %>%
  rename(
    age_99_plus = age_99
  ) %>%
  mutate(
    new_age_99_plus = age_99_plus - lag(age_99_plus) ,
    new_age_90_99 = age_90_99 - lag(age_90_99) ,
    new_age_80_89 = age_80_89 - lag(age_80_89) ,
    new_age_70_79 = age_70_79 - lag(age_70_79) ,
    new_age_60_69 = age_60_69 - lag(age_60_69) ,
    new_age_50_59 = age_50_59 - lag(age_50_59) ,
    new_age_40_49 = age_40_49 - lag(age_40_49) ,
    new_age_30_39 = age_30_39 - lag(age_30_39) ,
    new_age_20_29 = age_20_29 - lag(age_20_29) ,
    new_age_10_19 = age_10_19 - lag(age_10_19) ,
    new_age_0_9 = age_0_9 - lag(age_0_9)
  ) %>%
  select(
    date,
    epi_week,
    epi_year,
    new_age_99_plus,
    new_age_90_99,
    new_age_80_89,
    new_age_70_79,
    new_age_60_69,
    new_age_50_59,
    new_age_40_49,
    new_age_30_39,
    new_age_20_29,
    new_age_10_19,
    new_age_0_9
  ) %>%
  pivot_longer(
    cols=c(
      new_age_99_plus,
      new_age_90_99,
      new_age_80_89,
      new_age_70_79,
      new_age_60_69,
      new_age_50_59,
      new_age_40_49,
      new_age_30_39,
      new_age_20_29,
      new_age_10_19,
      new_age_0_9
    ),
    names_to = "age_group",
    values_to = "new_daily_cases"
  )

dashboard_demographics_weekly_ages_grouped <- dashboard_demographics_weekly_ages %>%
  group_by(
    age_group, epi_week
  ) %>%
  summarise(
    new_weekly_cases = sum(new_daily_cases)
  ) %>%
  pivot_wider(
    names_from = age_group,
    values_from = new_weekly_cases
  ) %>%
  mutate(
    new_cases_allages = rowSums(dplyr::across(starts_with("new_age_")), na.rm = T)
  ) %>%
  mutate(
    new_cases_allages = rowSums(dplyr::across(starts_with("new_age_")), na.rm = T),
    pct_new_age_99_plus = round(new_age_99_plus / new_cases_allages * 100, 1),
    pct_new_age_90_99 = round(new_age_90_99 / new_cases_allages * 100, 1),
    pct_new_age_80_89 = round(new_age_80_89 / new_cases_allages * 100, 1),
    pct_new_age_70_79 = round(new_age_70_79 / new_cases_allages * 100, 1),
    pct_new_age_60_69 = round(new_age_60_69 / new_cases_allages * 100, 1),
    pct_new_age_50_59 = round(new_age_50_59 / new_cases_allages * 100, 1),
    pct_new_age_40_49 = round(new_age_40_49 / new_cases_allages * 100, 1),
    pct_new_age_30_39 = round(new_age_30_39 / new_cases_allages * 100, 1),
    pct_new_age_20_29 = round(new_age_20_29 / new_cases_allages * 100, 1),
    pct_new_age_10_19 = round(new_age_10_19 / new_cases_allages * 100, 1),
    pct_new_age_0_9 = round(new_age_0_9 / new_cases_allages * 100, 1),
  ) %>%
  filter(
    epi_week < 20
  )


write_csv(dashboard_demographics_weekly_ages_grouped, dir_data_out(paste("dashboard_demographics_weekly_ages_grouped", '.csv', sep='')))


dashboard_demographics_weekly_ages_grouped_tall <- dashboard_demographics_weekly_ages_grouped %>%
  select(-starts_with("new_")) %>%
  pivot_longer(
    cols=c(
      pct_new_age_99_plus,
      pct_new_age_90_99,
      pct_new_age_80_89,
      pct_new_age_70_79,
      pct_new_age_60_69,
      pct_new_age_50_59,
      pct_new_age_40_49,
      pct_new_age_30_39,
      pct_new_age_20_29,
      pct_new_age_10_19,
      pct_new_age_0_9
    ),
    names_to = "age_group",
    values_to = "new_week_cases"
  ) %>%
  mutate(
    age_group = gsub("pct_new_age_", "", age_group, fixed=TRUE),
    age_group = gsub("_plus", " plus", age_group, fixed=TRUE),
    age_group = gsub("_", "-", age_group, fixed=TRUE)
  )


p_new_weekly_age_pct <- ggplot(dashboard_demographics_weekly_ages_grouped_tall %>% filter(age_group != "99 plus")) +
  aes(x = epi_week, weight = new_week_cases) +
  geom_bar(fill = wfp_blue) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 30),
    labels=function(x) { ifelse(x %in% c(30), paste(x, "%", sep=""), x) }
  ) +
  minimal_theme() +
  labs(
    title = wrap_text("Percentage of new weekly COVID-19 cases by age group", 70),
    # subtitle = wrap_text("New cases reported in 3Reported COVID-19 hospitalization counts limited to active and contagious cases prior to late December", 80),
    caption = wrap_text(paste("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH (", last_update_timestamp, ")", sep = ""), 110),
    x = "Epidemiological week (2021)",
    y = "",
    fill=""
  ) +
  theme(
    strip.background=ggplot2::element_blank(),
    strip.text=ggplot2::element_text(size =13, hjust=0, face="bold"),
    panel.border=ggplot2::element_blank()
  ) +
  facet_wrap(vars(age_group), nrow = 2)

wfp_new_weekly_age_pct <- prepare_plot(p_new_weekly_age_pct)

ggsave_pngpdf(wfp_new_weekly_age_pct, "wfp_new_weekly_age_pct", width_var=8.66, height_var=4, dpi_var=300, scale_var=1, units_var="in")




p_case_demographics <- ggplot(dashboard_demographics_allrha %>% filter(age_group != "99+")) +
  aes(x = date, y = total_cases, group = age_group) +
  geom_line(size=.75, alpha=1, colour=wfp_blue) +
  # geom_line(size = 1, alpha = .5, colour = "#c9c9c9") +
  # geom_line(data=dashboard_demographics_allrha %>% filter(date >= as.Date("2021-01-01")) %>% filter(age_group %in% c("0-9", "10-19")),
  #           size = 1, alpha = 1, colour = wfp_blue) +
  # geom_line(
  #   data = dashboard_demographics_allrha_2nd_wave %>% filter(age_group %in% c("0-9", "10-19")),
  #   aes(x = date, y = total_cases, group = age_group),
  #   size = 1, alpha = 1, colour = wfp_blue
  # ) +
  # geom_line(
  #   data = dashboard_demographics_allrha_3rd_wave %>% filter(age_group %in% c("0-9", "10-19")),
  #   aes(x = date, y = total_cases, group = age_group),
  #   size = 1, alpha = 1, colour = wfp_blue
  # ) +
  # geom_text_repel(
  #   data = dashboard_demographics_allrha %>% filter(date == max(date)),
  #   aes(x = date, y = total_cases,
  #       label = paste(age_group, ":", comma(total_cases, accuracy=1), sep=" "),
  #       fontface=ifelse(age_group %in% c("0-9", "10-19"), "bold", "plain")
  #   ),
  #   size = 4, colour = "#000000",
  #   hjust = -.5,
  #   color = "#222222",
  #   force=10,
  #   direction = "y",
  #   segment.color = "#999999",
  #   segment.size = .2,
  #   show.legend = FALSE
  #
  # ) +
#
#   annotate("text",
#            x=as.Date("2021-01-24"),
#            y=7200,
#            label=wrap_text("Between Jan. 1 and May 8, cases among 0-9 year olds increased by 138 per cent. Among 10-19 year olds, cases grew by 92 per cent in the same four month period.", 42),
#            hjust=1, vjust=0.8, size=4,
#            colour="#000000"
#   ) +

  scale_x_date(
    expand = c(0, 0),
    limits = c(as.Date("2020-09-15"), as.Date("2021-06-30")),
    date_breaks = "3 month",
    labels = date_format("%b")
  ) +
  scale_y_continuous(
    expand = c(0, 0),
    limits = c(0, 8000),
    label=comma
    # ,
    # labels = function(x) { ifelse(x %in% c(20), paste(x, "%", sep = ""), x) }
  ) +
  labs(
    title = wrap_text("Reported cases of COVID-19 in Manitoba by age group", 70),
    subtitle= wrap_text("All cases to date", 80),
    caption = wrap_text(toupper(paste("WINNIPEG FREE PRESS — SOURCE: Manitoba Health (", last_update_timestamp, ")", sep = "")), 80),
    x = "",
    y = "",
    colour = "Age group"
  ) +
  minimal_theme() +
  theme(
    # plot.title = ggplot2::element_text(margin=ggplot2::margin(0,0,20,0)),
    legend.position = c(.2, 1),
    legend.justification = c("right", "top"),
    legend.box.just = "right",
    legend.margin = margin(10, 10, 10, 10),
    panel.grid.major.x = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_blank(),
    panel.grid.minor.x = ggplot2::element_blank(),
    panel.grid.minor.y = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_line(color="#888888")
  ) +
  theme(
    strip.background=ggplot2::element_blank(),
    strip.text=ggplot2::element_text(size =13, hjust=0, face="bold"),
    panel.border=ggplot2::element_blank()
  ) +
  facet_wrap(vars(age_group), nrow = 2)

wfp_case_demographics_facet <- prepare_plot(p_case_demographics)
ggsave_pngpdf(wfp_case_demographics_facet, "wfp_case_demographics_facet", width_var = 8.66, height_var = 4, dpi_var=96, scale_var = 1, units_var = "in")

# ggplot(dashboard_demographics_allrha) +
#   aes(x = date, y = total_cases) +
#   geom_line(size = 1L, colour = "#0c4c8a") +
#   theme_minimal() +
#   facet_wrap(vars(age_group))
