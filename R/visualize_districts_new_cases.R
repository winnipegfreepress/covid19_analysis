

p_COVID19_MB_districts <- ggplot(COVID19_MB_districts %>% filter(rha=="Southern Health-Santé Sud"
)) +
  aes(x = date, y = value, group=area_name) +
  geom_line(size = .5, colour = "#c9c9c9") +
  geom_line(data=COVID19_MB_districts %>%
              filter(area_name %in% c("Morden", "Winkler", "Steinbach")),
            size = .5, colour = wfp_blue) +
  geom_point(data=COVID19_MB_districts %>%
               filter(date == max(date)) %>%
              filter(area_name %in% c("Morden", "Winkler", "Steinbach")),
            size = 1, colour = wfp_blue) +
  geom_text(data=COVID19_MB_districts %>% filter(date == max(date)) %>%
              filter(area_name %in% c("Morden", "Winkler", "Steinbach")),
            aes(x = date, y = value, group=area_name,
                label=paste(area_name, ": ", comma(value), sep="")
                ),
            size = 3, fontface="bold", colour = "black", hjust=-.15, vjust=-.5) +
  geom_text(data=COVID19_MB_districts %>% filter(date == max(date)) %>%
              filter(area_name %in% c("Morden", "Winkler", "Steinbach")),
            aes(x = date + 5, y = value, group=area_name,
                label=paste(new_14day_cases, "cases in the previous 14 days")),
            size = 3, colour = "black", hjust=.003 , vjust=1.1) +

  geom_line(data=COVID19_MB_districts %>%
              filter(area_name %in% c("Steinbach")),
            size = .5, colour = "#c9c9c9") +
  geom_point(data=COVID19_MB_districts %>%
               filter(date == max(date)) %>%
               filter(area_name %in% c("Steinbach")),
             size = 1, colour = "#c9c9c9") +
  geom_text(data=COVID19_MB_districts %>% filter(date == max(date)) %>%
              filter(area_name %in% c("Steinbach")),
            aes(x = date, y = value, group=area_name,
                label=paste(area_name, ": ", comma(value), sep="")
            ),
            size = 3, fontface="bold", colour = "#777777", hjust=-.15, vjust=-.5) +
  geom_text(data=COVID19_MB_districts %>% filter(date == max(date)) %>%
              filter(area_name %in% c("Steinbach")),
            aes(x = date + 5, y = value, group=area_name,
                label=paste(new_14day_cases, "cases in the previous 14 days")),
            size = 3, colour = "#777777", hjust=.003 , vjust=1.1) +

  scale_x_date(
    expand=c(0, 0),
    limits=c(as.Date("2020-10-01"), as.Date("2021-08-30")),
    date_breaks="1 month",
    date_minor_breaks="1 month",
    labels=date_format("%b")
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 1500),
    breaks=seq(0,1500,250),
    labels=scales::comma
  ) +
  labs(
    title=wrap_text("COVID-19 cases in  Southern Health districts", 70),
    subtitle=wrap_text("All reported cases", 100),
    caption = wrap_text(paste("WINNIPEG FREE PRESS — SOURCE: MANITOBA HEALTH (", last_update_timestamp, ")", sep = ""), 110),
    x="",
    y="",
    colour=""
  ) +
  minimal_theme()


wfp_COVID19_MB_districts <- prepare_plot(p_COVID19_MB_districts)
ggsave_pngpdf(wfp_COVID19_MB_districts, "wfp_COVID19_MB_districts_cases", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

