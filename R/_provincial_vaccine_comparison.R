
GET(
  "https://api.opencovid.ca/timeseries?stat=avaccine&loc=prov",
  write_disk(dir_data_raw("c19ca_vaccine_administererd.json"), overwrite = TRUE)
)
Sys.sleep(time_pause)


GET(
  "https://api.opencovid.ca/timeseries?stat=cvaccine&loc=prov",
  write_disk(dir_data_raw("c19ca_vaccine_completed.json"), overwrite = TRUE)
)
Sys.sleep(time_pause)

c19ca_vaccine_administered <- jsonlite::fromJSON(dir_data_raw("c19ca_vaccine_administererd.json"))
c19ca_vaccine_administered <- c19ca_vaccine_administered[["avaccine"]]
c19ca_vaccine_administered <- c19ca_vaccine_administered %>%
  mutate(
    date = as.Date(date_vaccine_administered, format = "%d-%m-%Y")
  )

c19ca_vaccine_completed <- jsonlite::fromJSON(dir_data_raw("c19ca_vaccine_completed.json"))
c19ca_vaccine_completed <- c19ca_vaccine_completed[["cvaccine"]]
c19ca_vaccine_completed <- c19ca_vaccine_completed %>%
  mutate(
    date = as.Date(date_vaccine_completed, format = "%d-%m-%Y")
  )


# provincial_population_2021 <- read_csv(dir_data_raw("provincial_population_12older_total_2020_1710000501.csv")) %>%
provincial_population_2021 <- read_csv(dir_data_raw("provincial_population_total_2021_17-10-0009-01.csv")) %>%
  clean_names() %>%
  mutate(
    province_alt = ifelse(province == "British Columbia", "BC",
      ifelse(province == "Newfoundland and Labrador", "NL",
        ifelse(province == "Prince Edward Island", "PEI",
          ifelse(province == "Northwest Territories", "NWT",
            province
          )
        )
      )
    )
  )


# Join the vaccinations for the latest date
provincial_vaccinations <- left_join(
  c19ca_vaccine_administered %>% filter(date == max(date)),
  c19ca_vaccine_completed %>% filter(date == max(date)),
  by = c("province" = "province")
) %>%
  rename(
    date = date.x
  ) %>%
  left_join(
    provincial_population_2021,
    by = c("province" = "province_alt")
  ) %>%
  select(
    -province
  ) %>%
  rename(
    province = province.y
  ) %>%
  mutate(
    cumulative_first_doses = cumulative_avaccine - cumulative_cvaccine,
    pct_one_dose = cumulative_first_doses / total_population * 100,
    pct_two_dose = cumulative_cvaccine / total_population * 100
  ) %>%
  select(
    date,
    province,
    total_population,
    avaccine,
    cvaccine,
    cumulative_avaccine,
    cumulative_cvaccine,
    cumulative_first_doses,
    pct_one_dose,
    pct_two_dose,
    date.y,
    date_vaccine_administered,
    date_vaccine_completed
  )

provincial_vaccinations_pct_tall <- provincial_vaccinations %>%
  select(
    province,
    pct_one_dose,
    pct_two_dose
  ) %>%
  pivot_longer(
    !province,
    names_to = "type",
    values_to = "pct"
  ) %>%
  mutate(
    type = gsub("pct_", "", type, fixed = TRUE),
    type = gsub("_", " ", type, fixed = TRUE)
  )


p_provincial_vax_pct_1st <- plot_bar_x_reordered_y(
  provincial_vaccinations_pct_tall %>% filter(type == "one dose"),
  x_var = province, y_var = pct,
  bar_colour = nominalMuted_shade_0,
  title_str = "Percentage of population with at least one dose of a COVID-19 vaccine",
  subtitle_str = "", x_str = "", y_str = "",
  ymin = 0, ymax = 100, y_units = "%",
  source_str = "COVID-19 Canada Open Data Working Group, Statistics Canada", lastupdate_str = last_update_timestamp
)

p_provincial_vax_pct_1st <- p_provincial_vax_pct_1st +
  geom_text(
    data = provincial_vaccinations_pct_tall %>% filter(type == "one dose"),
    aes(
      x = reorder(province, pct), y = pct - 1,
      label = wrap_text(paste(
        round(pct, 1),
        # "%",
        sep = ""
      ), 40)
    ),
    hjust = 1, vjust = .4, size = 3.5, color = "#222222"
  ) +
  geom_col(
    data = provincial_vaccinations_pct_tall %>% filter(type == "one dose") %>% filter(province == "Manitoba"),
    aes(x = reorder(province, pct), y = pct),
    colour = wfp_blue, fill = wfp_blue
  ) +
  geom_text(
    data = provincial_vaccinations_pct_tall %>% filter(type == "one dose") %>% filter(province == "Manitoba"),
    aes(
      x = reorder(province, pct), y = pct - 1,
      label = wrap_text(paste(
        round(pct, 1),
        # "%",
        sep = ""
      ), 40)
    ),
    hjust = 1, vjust = .4, fontface = "bold", size = 3.5, color = "#ffffff"
  ) +
  scale_y_continuous(
    expand = c(0, 0),
    limits = c(0, 140),
    labels = function(x) {
      ifelse(x == 100, paste(x, "%", sep = ""),
             ifelse(x > 100, "",
                    x))
    }
  ) +
  labs(
    caption = paste("Vaccination percentages may differ from provincial estimates due to discrepancies in population projections and \npublished vaccination counts.",
      # " ",
      # comma(mb_12plus_population_2020estimate),
      # " eligible Manitobans age 12 or older",
      "\n\n",
      toupper("Winnipeg Free Press"),
      " — SOURCE: ",
      toupper("COVID-19 Canada Open Data Working Group, Statistics Canada"),
      " (", last_update_timestamp, ")",
      sep = ""
    )
  ) +
  minimal_theme() +
  theme(
    axis.title.x = ggplot2::element_text(size = 10, color = "#222222"),
    axis.text.x = ggplot2::element_text(size = 10, color = "#222222"),
    axis.ticks.x = ggplot2::element_line(color = "#888888"),
    axis.title.y = ggplot2::element_text(size = 10, color = "#222222"),
    axis.text.y = ggplot2::element_text(size = 10, color = "#222222"),
    axis.ticks.y = ggplot2::element_line(color = "#888888"),

    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_blank(),
    panel.grid.minor.x = ggplot2::element_blank(),
    panel.grid.minor.y = ggplot2::element_blank()
  )

wfp_provincial_vax_pct_1st <- prepare_plot(p_provincial_vax_pct_1st)
ggsave_pngpdf(wfp_provincial_vax_pct_1st, "wfp_provincial_vax_pct_1st", width_var = 8.66, height_var = 6, dpi_var = 300, scale_var = 1, units_var = "in")


p_provincial_vax_pct_2nd <- plot_bar_x_reordered_y(
  provincial_vaccinations_pct_tall %>% filter(type == "two dose"),
  x_var = province, y_var = pct,
  bar_colour = nominalMuted_shade_0,
  title_str = "Percentage of total population that is fully vaccinated",
  subtitle_str = "", x_str = "", y_str = "",
  ymin = 0, ymax = 100, y_units = "%",
  source_str = "COVID-19 Canada Open Data Working Group, Statistics Canada", lastupdate_str = last_update_timestamp
)

p_provincial_vax_pct_2nd <- p_provincial_vax_pct_2nd +
  geom_text(
    data = provincial_vaccinations_pct_tall %>% filter(type == "two dose"),
    aes(
      x = reorder(province, pct), y = pct - 1,
      label = wrap_text(paste(
        round(pct, 1),
        # "%",
        sep = ""
      ), 40)
    ),
    hjust = 1, vjust = .4, size = 3.5, color = "#222222"
  ) +
  geom_col(
    data = provincial_vaccinations_pct_tall %>% filter(type == "two dose") %>% filter(province == "Manitoba"),
    aes(x = reorder(province, pct), y = pct),
    colour = wfp_blue, fill = wfp_blue
  ) +
  geom_text(
    data = provincial_vaccinations_pct_tall %>% filter(type == "two dose") %>% filter(province == "Manitoba"),
    aes(
      x = reorder(province, pct), y = pct - 1,
      label = wrap_text(paste(
        round(pct, 1),
        # "%",
        sep = ""
      ), 40)
    ),
    hjust = 1, vjust = .4, fontface = "bold", size = 3.5, color = "#ffffff"
  ) +
  scale_y_continuous(
    expand = c(0, 0),
    limits = c(0, 100),
    labels = function(x) {
      ifelse(x == 100, paste(x, "%", sep = ""),
             ifelse(x > 100, "",
                    x))
    }
  ) +
  labs(
    caption = paste("Vaccination percentages may differ from provincial estimates due to discrepancies in population projections and \npublished vaccination counts.",
      "\n",
      toupper("Winnipeg Free Press"),
      " — SOURCE: ",
      toupper("COVID-19 Canada Open Data Working Group, Statistics Canada"),
      " (", last_update_timestamp, ")",
      sep = ""
    )
  ) +
  minimal_theme() +
  theme(
    axis.title.x = ggplot2::element_text(size = 10, color = "#222222"),
    axis.text.x = ggplot2::element_text(size = 10, color = "#222222"),
    axis.ticks.x = ggplot2::element_line(color = "#888888"),
    axis.title.y = ggplot2::element_text(size = 10, color = "#222222"),
    axis.text.y = ggplot2::element_text(size = 10, color = "#222222"),
    axis.ticks.y = ggplot2::element_line(color = "#888888"),

    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.x = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_blank(),
    panel.grid.minor.x = ggplot2::element_blank(),
    panel.grid.minor.y = ggplot2::element_blank()
  )

wfp_provincial_vax_pct_2nd <- prepare_plot(p_provincial_vax_pct_2nd)
ggsave_pngpdf(wfp_provincial_vax_pct_2nd, "wfp_provincial_vax_pct_2nd", width_var = 8.66, height_var = 6, dpi_var = 300, scale_var = 1, units_var = "in")




# Try 2-up


p_title <- paste("Percentage of total population with a COVID-19 vaccination")
p_title.p <- ggparagraph(text=p_title, face="bold", size=16, lineheight=1, color="black", margin(.2,0.2,0,0.2, "cm"))

p_subtitle <- paste(" ")
p_subtitle.p <- ggparagraph(text=p_subtitle, size=14, lineheight=1, color="black", margin(0,0.2,0,0.2, "cm"))

p_credit_source=paste("Vaccination percentages may differ from provincial estimates due to discrepancies in population projections and vaccination counts.",
                      "\n\n",
                      toupper("Winnipeg Free Press"),
                      " — SOURCE: ",
                      toupper("COVID-19 Canada Open Data Working Group, Statistics Canada"),
                      " (", last_update_timestamp, ")",
                      sep = ""
)
p_credit_source.p <- text_grob(
  x=0,
  y=0,
  label=p_credit_source,
  hjust=0,
  vjust=0,
  color="black",
  face="plain",
  size=10,
  lineheight=1
)

p_provincial_vax_pct_1st_sq <- p_provincial_vax_pct_1st +
  labs(
    title="",
    subtitle="One dose",
    caption=""
  ) +
  theme(
    plot.subtitle=ggplot2::element_text(size=14, face="bold", lineheight=1, color="#222222", margin=ggplot2::margin(5,0,20,0)),
  )

p_provincial_vax_pct_2nd_sq <- p_provincial_vax_pct_2nd +
  labs(
    title="",
    subtitle="Two doses",
    caption=""
  ) +
  theme(
    plot.subtitle=ggplot2::element_text(size=14, face="bold", lineheight=1, color="#222222", margin=ggplot2::margin(5,0,20,0)),
  )


p_provincial_vax_pct_1st_2nd_2up <-  ggarrange(
    p_provincial_vax_pct_1st_sq,
    p_provincial_vax_pct_2nd_sq,
    labels=c("", "", ""),
    ncol=2, nrow=1,
    widths=c(.5, .5)
  ) +
  theme(plot.margin=margin(0,0,0,0, "cm"))

p_provincial_vax_pct_1st_2nd <-  ggarrange(
  p_title.p,
  # p_subtitle.p,
  p_provincial_vax_pct_1st_2nd_2up,
  p_credit_source.p,
  labels=c("", "", ""),
  ncol=1,
  nrow=3,
  heights=c(.4, 5, .1)
) +
  theme(plot.margin=margin(.4,.25,.25,.25, "cm"))

ggsave_pngpdf(p_provincial_vax_pct_1st_2nd, "wfp_provincial_vax_pct_1st_2nd", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
