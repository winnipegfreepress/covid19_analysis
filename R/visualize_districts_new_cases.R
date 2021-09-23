
districts_southern_df <-  districts_df %>%
  filter(rha=="Southern Health-Santé Sud") %>%
  filter(rha != area_name) %>%
  filter(area_name != "Unknown District") %>%
  select(date, rha, area_name, value) %>%
  group_by(area_name) %>%
  arrange(date) %>%
  mutate(
    new_cases_diff = value - lag(value),
    cases_mavg_7day=roll_mean(new_cases_diff, 7, na.rm=TRUE, fill=NA, align="right"),
    cases_mavg_14day=roll_mean(new_cases_diff, 14, na.rm=TRUE, fill=NA, align="right")
  ) %>%
  ungroup() %>%
  left_join(
    manitoba_health_districts_populations,
    by=c("rha"="rha", "area_name"="district")
  ) %>%
  mutate(
    new_cases_7day_100K = (cases_mavg_7day / pop_2019) * 100000
  )

write_csv(districts_southern_df, dir_data_out(paste("districts_southern_df", ".csv", sep = "")))

p_COVID19_MB_districts <- ggplot(districts_southern_df) +
  aes(x = date, y = cases_mavg_7day, group=area_name) +
  geom_line(size = .5, colour = "#c9c9c9") +

  geom_text_repel(
    data=districts_southern_df %>% filter(date == max(date)) %>%
      # filter(area_name %in% c("Morden", "Winkler", "Steinbach")),
      filter(cases_mavg_7day >= 1),
    aes(x = date,
        y = cases_mavg_7day,
        group = area_name,
        label=paste(area_name, ": ", format(cases_mavg_7day, digits=2), sep="")
        # label=paste(area_name, " ", sep="")
    ),
    color="#222222",
    size=4,
    hjust=-.75,
    # vjust=-.25,
    direction="y",
    segment.color="#222222",
    segment.size=.2,
    show.legend=FALSE
  ) +

  geom_line(data=districts_southern_df %>%
              # filter(area_name %in% c("Morden", "Winkler", "Steinbach"))
            filter(cases_mavg_7day >= 1),
            colour = wfp_blue,
            size = .5) +


  scale_x_date(
    expand=c(0, 0),
    limits=as.Date(c("2021-08-30","2021-10-01")),
    date_breaks="2 weeks",
    labels=date_format("%b %d" )
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 10),
    # breaks=seq(0,1500,250),
    labels=scales::comma
  ) +
  labs(
    title=wrap_text("COVID-19 cases in  Southern Health districts", 70),
    subtitle=wrap_text("Seven-day moving average of new daily cases", 80),
    caption = wrap_text(paste("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH (", last_update_timestamp, ")", sep = ""), 110),
    x="",
    y="",
    colour=""
  ) +
  minimal_theme()


wfp_COVID19_MB_districts_southern <- prepare_plot(p_COVID19_MB_districts)
ggsave_pngpdf(wfp_COVID19_MB_districts_southern, "wfp_COVID19_MB_districts_southern", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")


p_COVID19_MB_districts_7day_100K <- ggplot(districts_southern_df) +
  aes(x = date, y = new_cases_7day_100K, group=area_name) +
  geom_line(size = .5, colour = "#c9c9c9") +

  geom_text_repel(
    data=districts_southern_df %>% filter(date == max(date)) %>%
      filter(new_cases_7day_100K >= 5),
      # filter(area_name %in% c("Morden", "Winkler", "Steinbach")),
    # filter(new_cases_7day_100K >= 1),
    aes(x = date,
        y = new_cases_7day_100K,
        group = area_name,
        label=paste(area_name, ": ", format(new_cases_7day_100K, digits=2), " cases /100K", sep="")
        # label=paste(area_name, " ", sep="")
    ),
    color="#222222",
    size=4,
    hjust=-.75,
    # vjust=-.25,
    direction="y",
    segment.color="#c9c9c9",
    segment.size=.2,
    show.legend=FALSE
  ) +

  geom_line(data=districts_southern_df %>%
              # filter(area_name %in% c("Morden", "Winkler", "Steinbach")),
              filter(new_cases_7day_100K >= 5),
            colour = wfp_blue,
            size = .5) +


  scale_x_date(
    expand=c(0, 0),
    limits=as.Date(c("2021-08-30","2021-11-01")),
    date_breaks="2 weeks",
    labels=date_format("%b %d" )
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 80),
    # breaks=seq(0,1500,250),
    labels=scales::comma
  ) +
  labs(
    title=wrap_text("New COVID-19 cases per 100,000 in Southern Health districts", 70),
    subtitle=wrap_text("Seven-day moving average of new daily cases per capita", 80),
    caption = wrap_text(paste("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH (", last_update_timestamp, ")", sep = ""), 110),
    x="",
    y="",
    colour=""
  ) +
  minimal_theme()


wfp_COVID19_MB_districts_7day_100K <- prepare_plot(p_COVID19_MB_districts_7day_100K)
ggsave_pngpdf(wfp_COVID19_MB_districts_7day_100K, "wfp_COVID19_MB_districts_7day_100K", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

