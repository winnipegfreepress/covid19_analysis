
################################################################################
# COVID-19 variants
################################################################################
covid19_variants <- read_feather(dir_data_processed("covid19_variants.feather"))
dashboard_variants_of_concern <- read_feather(dir_data_processed("dashboard_variants_of_concern.feather"))


dashboard_variants_of_concern_type <- dashboard_variants_of_concern %>%
  mutate(
    variant = case_when(
      variant == "B.1.1.7" ~ "B.1.1.7 (Alpha)",
      variant == "B.1.351" ~ "B.1.351 (Beta)",
      variant == "P.1" ~ "P.1 (Gamma)",
      variant == "B.1.617" ~ "B.1.617",
      variant == "B.1.617.1" ~ "B.1.617.1",
      variant == "B.1.617.2" ~ "B.1.617.2 (Delta)",
      TRUE ~ variant
    )
  ) %>%
  select(variant, cases) %>%
  group_by(variant) %>%
  summarize(
    total=sum(cases, na.rm=TRUE)
  )


dashboard_variants_of_concern_transmission <- dashboard_variants_of_concern %>%
  select(-objectid) %>%
  mutate(
    variant = case_when(
      variant == "B.1.1.7" ~ "B.1.1.7 (Alpha)",
      variant == "B.1.351" ~ "B.1.351 (Beta)",
      variant == "P.1" ~ "P.1 (Gamma)",
      variant == "B.1.617" ~ "B.1.617",
      variant == "B.1.617.1" ~ "B.1.617.1",
      variant == "B.1.617.2" ~ "B.1.617.2 (Delta)",
      TRUE ~ variant
    )
  ) %>%
  group_by(rha, variant, staging) %>%
  summarize(
    total=sum(cases, na.rm=TRUE)
  ) %>%
  pivot_wider(
    names_from=rha,
    values_from=total
  ) %>%
  clean_names() %>%
  mutate(
    voc_cases_total=interlake_eastern + northern + prairie_mountain_health + southern_health_sante_sud + winnipeg
  ) %>%
  select(
    variant, staging, voc_cases_total
  )

