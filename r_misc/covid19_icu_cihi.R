
  covid19_hospitalizations_icu_CIHI <- read_csv("data/raw/covid19-hospitalizations - CIHI.csv") %>%
    clean_names() %>%
    filter(province_territory != "Canada (excluding Quebec)") %>%
    rename(
      hospitalizations_w_icu = hospitalizations_number_of_covid_19_hospitalizations_with_icu_admission
    ) %>%
    mutate(
      hospitalizations_w_icu = gsub(",", "", hospitalizations_w_icu),
      hospitalizations_w_icu = as.numeric(as.character(hospitalizations_w_icu)),
      icu_rate = hospitalizations_w_icu / population_q1_2021 * 100000
    ) %>%
    select(
      -icu_rate_100k
    ) %>%
    rename(
      icu_rate_100k = icu_rate
    ) %>%
    mutate(
      province_territory = case_when(
        .$province_territory == "Ont." ~ "ON",
        .$province_territory == "Man." ~ "MB",
        .$province_territory == "B.C." ~ "BC",
        .$province_territory == "Canada" ~ "CA",
        .$province_territory == "Sask." ~ "SK",
        .$province_territory == "Alta." ~ "AB",
        .$province_territory == "N.S." ~ "NS",
        .$province_territory == "N.B." ~ "NB",
        .$province_territory == "Nun." ~ "NU",
        .$province_territory == "Y.T." ~ "YT",
        .$province_territory == "Unknown" ~ "NA",
        .$province_territory == "QC" ~ "QC",
        .$province_territory == "P.E.I." ~ "PEI",
        .$province_territory == "N.W.T." ~ "NWT",
        .$province_territory == "N.L." ~ "NL",
        is.na(.$province_territory) ~ "XXXX",
        TRUE ~ "ok"
      )
    )

  # Canada excludes quebec

  p_covid19_hospitalizations_icu_CIHI <- plot_bar_x_reordered_y(
    covid19_hospitalizations_icu_CIHI %>% filter(!is.na(icu_rate_100k)),
    x_var=province_territory, y_var=icu_rate_100k,
    bar_colour = nominalMuted_shade_0,
    title_str=
    "ICU admission rates for COVID-19 in Canada",
    subtitle_str="Hospitalizations with ICU admission, January to November 2020", x_str="", y_str="",
    y_units="", ymin=0, ymax=25,
    source_str="Canadian Institute for Health Information", lastupdate_str=last_update_timestamp
  )

  p_covid19_hospitalizations_icu_CIHI <- p_covid19_hospitalizations_icu_CIHI +
    geom_bar(data=covid19_hospitalizations_icu_CIHI %>% filter(province_territory=="MB"),
             aes(x=reorder(province_territory, icu_rate_100k), y=icu_rate_100k),
             fill=wfp_blue,
             colour=wfp_blue,
             stat="identity"
    ) +
    geom_text(
      data=covid19_hospitalizations_icu_CIHI %>% filter(!is.na(icu_rate_100k)),
      aes(
        label=
          ifelse(icu_rate_100k==0, 0, format(as.numeric(icu_rate_100k), digits=3))
      ),
      size=4, hjust=-.15, vjust=.4,
      position="identity",
      color="#222222"
    ) +
    labs(
      caption = wrap_text(
                      paste(
                        "Excludes Quebec. Data for Newfoundland and Labrador, Prince Edward Island, Northwest Territories and Yukon is suppressed due to low volumes (fewer than 5) and not reportable.",
                        "\n\n",
                        toupper(paste("WINNIPEG FREE PRESS — SOURCE: ", "Canadian Institute for Health Information", " (", last_update_timestamp, ")",sep = ""))
                      ), 120)
    ) +
    theme(
      plot.caption = ggplot2::element_text(lineheight=1.1, margin=ggplot2::margin(5,0,0,0)),

    )

  wfp_covid19_hospitalizations_icu_CIHI <- prepare_plot(p_covid19_hospitalizations_icu_CIHI)
  ggsave_pngpdf(wfp_covid19_hospitalizations_icu_CIHI, "wfp_covid19_hospitalizations_icu_CIHI", width_var=8.66, height_var=6, dpi_var=96, scale_var=1, units_var="in")

