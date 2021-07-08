
covid19_variants <- read_csv(dir_data_raw("covid_variants.csv")) %>%
  clean_names() %>%
  mutate(
    uncategorized=ifelse(is.na(uncategorized), 0, uncategorized)
  ) %>%
  rowwise() %>%
  mutate(total_variant_cases=b_1_1_7 + b_1_351 + p_1 + b_1_617 + uncategorized) %>%
  pivot_longer(
    -province,
    names_to="variant",
    values_to="count"
  ) %>%
  mutate(
    variant=ifelse(variant=="b_1_1_7", "B.1.1.7",
            ifelse(variant=="b_1_351", "B.1.351",
            ifelse(variant=="p_1", "P.1",
            ifelse(variant=="b_1_617", "B.1.617",
            ifelse(variant=="uncategorized", "Uncategorized",
            ifelse(variant=="total_variant_cases", "Total",
            "P.1"
        ))))))
  )

covid19_variants_total <- covid19_variants %>%
  filter(variant == "Total")

covid19_variants <-covid19_variants %>%
  filter(variant != "Total") %>%
  left_join(
    covid19_variants_total,
    by=c("province"="province")
  ) %>%
  rename(
    "variant"="variant.x",
    "count"="count.x",
    "total"="count.y"
  ) %>%
  select(
    -variant.y
  ) %>%
  left_join(
    population_provinces_2020,
  by=c("province"="province")
  ) %>%
  mutate(
    per_capita=count / population * 100000
  )



dashboard_variants_of_concern <- jsonlite::fromJSON(dir_data_raw('mbdata_variant_of_concern_cases.json'))
dashboard_variants_of_concern <- dashboard_variants_of_concern[["features"]][["properties"]]
dashboard_variants_of_concern <- dashboard_variants_of_concern %>%
    janitor::make_clean_names()




write_feather(covid19_variants, dir_data_processed("covid19_variants.feather"))
write_feather(dashboard_variants_of_concern, dir_data_processed("dashboard_variants_of_concern.feather"))




