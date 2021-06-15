

COVID19_MB_vaccine_distribution <- read_feather(dir_data_processed("vaccine_distribution.feather"))

# Vaccination summary incl distribution topline
COVID19_MB_vaccination_summary <- read_feather(dir_data_processed("COVID19_MB_vaccination_summary.feather"))

# Transform processed file to tall for graphics
COVID19_MB_first_second_vaccine_dose <- read_feather(dir_data_processed("COVID19_MB_first_second_vaccine_dose.feather"))

COVID19_MB_first_second_vaccine_dose__tall <- COVID19_MB_first_second_vaccine_dose %>%
  select(
    vaccination_date,
    cumulative_first_doses,
    cumulative_second_doses
  ) %>%
  mutate(
    remainder_first_doses=cumulative_first_doses - cumulative_second_doses
  ) %>%
  pivot_longer(
    !vaccination_date,
    names_to="type",
    values_to="count"
  ) %>%
  mutate(
    type_str=ifelse(type == "cumulative_first_doses", "First dose", "Second dose"),
    type_str=ifelse(type == "remainder_first_doses", "First dose only", type_str),
    type=factor(type, levels=c("cumulative_first_doses", "cumulative_second_doses", "remainder_first_doses")),
    count=ifelse(is.na(count), 0, count)
  )

COVID19_MB_first_second_vaccine_dose__last <- COVID19_MB_first_second_vaccine_dose__tall %>%
  filter(!is.na(vaccination_date)) %>%
  filter(vaccination_date == max(vaccination_date))

cumulative_first_doses_cnt <- COVID19_MB_first_second_vaccine_dose__last %>% filter(type=="cumulative_first_doses") %>% select(count) %>% pull()
cumulative_first_only_doses_cnt <- COVID19_MB_first_second_vaccine_dose__last %>% filter(type=="remainder_first_doses") %>% select(count) %>% pull()
cumulative_second_doses_cnt <- COVID19_MB_first_second_vaccine_dose__last %>% filter(type=="cumulative_second_doses") %>% select(count) %>% pull()




wfp_covid_19_mb_vaccinations_last <- COVID19_MB_first_second_vaccine_dose %>% filter(vaccination_date == max(vaccination_date))
wfp_covid_19_mb_vaccinations_last_date <- wfp_covid_19_mb_vaccinations_last$vaccination_date
wfp_covid_19_mb_vaccinations_last_first <- wfp_covid_19_mb_vaccinations_last$cumulative_first_doses
wfp_covid_19_mb_vaccinations_last_second <- wfp_covid_19_mb_vaccinations_last$cumulative_second_doses

wfp_covid_19_mb_vaccinations_21days_prior <- wfp_covid_19_mb_vaccinations_last_date - 21
wfp_covid_19_mb_vaccinations_21days <- COVID19_MB_first_second_vaccine_dose %>% filter(vaccination_date == wfp_covid_19_mb_vaccinations_21days_prior)
wfp_covid_19_mb_vaccinations_21days_date <- wfp_covid_19_mb_vaccinations_21days$vaccination_date
wfp_covid_19_mb_vaccinations_21days_first <- wfp_covid_19_mb_vaccinations_21days$cumulative_first_doses
wfp_covid_19_mb_vaccinations_21days_second <- wfp_covid_19_mb_vaccinations_21days$cumulative_second_doses

wfp_covid_19_mb_vaccinations_28days_prior <- wfp_covid_19_mb_vaccinations_last_date - 28
wfp_covid_19_mb_vaccinations_28days <- COVID19_MB_first_second_vaccine_dose %>% filter(vaccination_date == wfp_covid_19_mb_vaccinations_28days_prior)
wfp_covid_19_mb_vaccinations_28days_date <- wfp_covid_19_mb_vaccinations_28days$vaccination_date
wfp_covid_19_mb_vaccinations_28days_first <- wfp_covid_19_mb_vaccinations_28days$cumulative_first_doses
wfp_covid_19_mb_vaccinations_28days_second <- wfp_covid_19_mb_vaccinations_28days$cumulative_second_doses


# Vaccine demographics
COVID19_MB_vaccine_demographics <- read_feather(dir_data_processed("COVID19_MB_vaccine_demographics_raw.feather"))

COVID19_MB_vaccine_demographics <-  as.data.frame(COVID19_MB_vaccine_demographics)


all_doses_administered <- COVID19_MB_vaccine_demographics %>%
  filter(sex == "All")

female_doses_administered <- COVID19_MB_vaccine_demographics %>%
  filter(sex == "Female")

male_doses_administered <- COVID19_MB_vaccine_demographics %>%
  filter(sex == "Male")

all_first_doses_administered_cnt <- sum(all_doses_administered$first_doses_administered, na.rm=TRUE)
all_second_doses_administered_cnt <- sum(all_doses_administered$second_doses_administered, na.rm=TRUE)

female_first_doses_administered_cnt <- sum(female_doses_administered$first_doses_administered, na.rm=TRUE)
female_second_doses_administered_cnt <- sum(female_doses_administered$second_doses_administered, na.rm=TRUE)
male_first_doses_administered_cnt <- sum(male_doses_administered$first_doses_administered, na.rm=TRUE)
male_second_doses_administered_cnt <- sum(male_doses_administered$second_doses_administered, na.rm=TRUE)


COVID19_MB_vaccine_demographics_bothgenders_tall <- COVID19_MB_vaccine_demographics %>%
  filter(sex == "All") %>%
  select(-sex, -total_doses_administered) %>%
  pivot_longer(
    -age_group,
    names_to="dose_type",
    values_to="doses_administered_ttd"
  ) %>%
  mutate(
    age_group=factor(age_group, levels=c("10-19", "20-29", "30-39", "40-49", "50-59", "60-69", "70-79", "80-89", "90-99", "99+")),
    # sex_dose_type_fac=paste(sex, "_", dose_type, sep=""),
    dose_type_str=ifelse(dose_type == "first_doses_administered", "First doses administered", "Second doses administered"),
    dose_type=factor(dose_type, levels=c("first_doses_administered", "second_doses_administered")),
    # sex=factor(sex, levels=c("Female", "Male")),
    # sex_dose_type_fac=factor(sex_dose_type_fac, levels=c("Female_first_doses_administered", "Female_second_doses_administered", "Male_first_doses_administered", "Male_second_doses_administered"))
  )

COVID19_MB_vaccine_demographics_male_tall <- COVID19_MB_vaccine_demographics %>%
  filter(sex == "Male") %>%
  select(-sex, -total_doses_administered) %>%
  pivot_longer(
    -age_group,
    names_to="dose_type",
    values_to="doses_administered_ttd"
  ) %>%
  mutate(
    sex="Male"
  )


COVID19_MB_vaccine_demographics_female_tall <- COVID19_MB_vaccine_demographics %>%
  filter(sex == "Female") %>%
  select(-sex, -total_doses_administered) %>%
  pivot_longer(
    -age_group,
    names_to="dose_type",
    values_to="doses_administered_ttd"
  ) %>%
  mutate(
    sex="Female"
  )


COVID19_MB_vaccine_demographics_tall <- rbind(
  COVID19_MB_vaccine_demographics_female_tall,
  COVID19_MB_vaccine_demographics_male_tall
) %>%
mutate(
  sex_dose_type_fac=paste(sex, "_", dose_type, sep=""),
  dose_type_str=ifelse(dose_type == "first_doses_administered", "First doses administered", "Second doses administered"),
  dose_type=factor(dose_type, levels=c("first_doses_administered", "second_doses_administered")),
  sex=factor(sex, levels=c("Female", "Male")),
  sex_dose_type_fac=factor(sex_dose_type_fac, levels=c("Female_first_doses_administered", "Female_second_doses_administered", "Male_first_doses_administered", "Male_second_doses_administered"))
)


# Vaccine distribution
covid_vaccine <- read_feather(dir_data_processed("covid_vaccine.feather"))

covid_vaccine_diff_mb_tall <- covid_vaccine %>%
  filter(province == "Manitoba") %>%
  select(
    date,
    cumulative_avaccine,
    cumulative_dose_difference
  ) %>%
  pivot_longer(
    cols=c("cumulative_avaccine", "cumulative_dose_difference"),
    names_to="type",
    values_to="count"
  ) %>%
  mutate(
    type=ifelse(type=="cumulative_dose_difference", "Unused doses", "Administered doses")
  ) %>%
  mutate(
    type=factor(type, levels=c("Unused doses", "Administered doses"))
  )


covid_vaccine_unused_compare <- covid_vaccine %>%
  filter(date == max(date)) %>%
  select(
    province, cumulative_dvaccine, cumulative_avaccine, dose_difference
  ) %>%
  mutate(
    pct_unused=dose_difference / (cumulative_avaccine + dose_difference ) * 100,
    pct_used=cumulative_avaccine / (cumulative_avaccine + dose_difference ) * 100,
  ) %>%
  select(
    province, pct_unused, pct_used, cumulative_dvaccine, cumulative_avaccine, dose_difference,
  ) %>%
  pivot_longer(
    cols=c("pct_unused", "pct_used"),
    names_to="type",
    values_to="pct"
  ) %>%
  mutate(
    type=ifelse(type=="pct_unused", "Unused doses", "Administered doses")
  ) %>%
  mutate(
    type=factor(type, levels=c("Unused doses", "Administered doses"))
  )

covid_vaccine_unused_compare_tall_used_only <- covid_vaccine_unused_compare %>%
  filter(type=="Administered doses") %>%
  select(
    province, pct
  ) %>%
  rename(
    pr=province,
    pct_used=pct
  )

covid_vaccine_unused_compare_tall <- left_join(
  covid_vaccine_unused_compare,
  covid_vaccine_unused_compare_tall_used_only,
  by=c("province"="pr")
)


################################################################################
# First dose demographic coverage
################################################################################
MB_pop_estimates_2020 <- MB_pop_estimates_2020_statcan_17_10_0005_01 %>%
  group_by(age_group) %>%
  summarise(sumpop=sum(population_2020est)) %>%
  ungroup() %>%
  mutate(
    age_group=ifelse(age_group == "100+", "99+", age_group)
  )

COVID19_MB_vaccine_age_groups <- COVID19_MB_vaccine_demographics_bothgenders_tall %>%
  filter(!is.na(age_group)) %>%
  filter(dose_type == "first_doses_administered") %>%
  select("age_group", "dose_type", "doses_administered_ttd")


FN_vaccinations <- read_feather(dir_data_processed("FN_vaccinations.feather"))

COVID19_MB_vaccine_demographics_coverage <- left_join(
  mbhealth_population_agegroups,
  COVID19_MB_vaccine_age_groups,
  by=c("age_group"="age_group")
) %>%
  rename(
    first_dose_mb=doses_administered_ttd
  ) %>%
  mutate(
    first_dose_mb=as.numeric(first_dose_mb)
  ) %>%
  rowwise() %>%
  mutate(
    # first_dose_total=sum(first_dose_fn, first_dose_mb, na.rm=TRUE),
    first_dose_total=first_dose_mb
  )

# Sum up the 90+ vaccinations and populations
COVID19_MB_vaccine_demographics_coverage_90plus <- COVID19_MB_vaccine_demographics_coverage %>%
  filter(age_group %in% c("90-99", "99+"))
COVID19_MB_vaccine_demographics_coverage_90plus2 <- as.data.frame(COVID19_MB_vaccine_demographics_coverage_90plus)

COVID19_MB_vaccine_demographics_coverage_90plus <- COVID19_MB_vaccine_demographics_coverage_90plus2 %>%
  summarise(
    population_age=sum(population_age, na.rm=T),
    first_dose_mb=sum(first_dose_mb, na.rm=T),
    # first_dose_fn=sum(first_dose_fn, na.rm=T),
    first_dose_total=sum(first_dose_total, na.rm=T)
  ) %>%
  mutate(
    age_group="90 plus",
    dose_type="first_doses_administered"
  ) %>%
  select(
    "age_group",
    "population_age",
    "dose_type",
    "first_dose_mb",
    # "first_dose_fn",
    "first_dose_total"
  )


COVID19_MB_vaccine_demographics_coverage_df <- as.data.frame(COVID19_MB_vaccine_demographics_coverage)

COVID19_MB_vaccine_demographics_coverage_df <- COVID19_MB_vaccine_demographics_coverage_df %>%
  filter(age_group %notin% c("90-99", "99+")) %>%
  rbind(COVID19_MB_vaccine_demographics_coverage_90plus) %>%
  mutate(
    pct_vaccinated_fullpop=first_dose_total / population_age * 100
  )
