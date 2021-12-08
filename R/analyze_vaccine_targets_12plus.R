
# Province via Brian Smiley provided 12+ pop estimate based on PHIMS records
# mb_12plus_population_2020estimate <- 1068553 + 111322
mb_12plus_population_2020estimate <- 1175703
mb_18plus_population_2020estimate <- 1068553

mb_12plus_population_2020estimate_25pct=mb_12plus_population_2020estimate * .25
mb_12plus_population_2020estimate_50pct=mb_12plus_population_2020estimate * .5
mb_12plus_population_2020estimate_70pct=mb_12plus_population_2020estimate * .7


phac_covid_vaccine_mb_current <- COVID19_MB_first_second_vaccine_dose %>%
  rename(
    date=vaccination_date
  ) %>%
  mutate(
    daily_doses_7dayavg_projected=first_doses,
    daily_doses_5K_projected=first_doses,
    daily_doses_10K_projected=10000,
    daily_doses_12K_projected=12000,
    daily_doses_20K_projected=20000,
    cumsum_daily_doses_7dayavg_projected=0,
    cumsum_daily_doses_5K_projected=0,
    cumsum_daily_doses_10K_projected=0,
    cumsum_daily_doses_12K_projected=0,
    cumsum_daily_doses_20K_projected=0
  )

phac_covid_vaccine_mb_current <- as.data.frame(phac_covid_vaccine_mb_current)

maxdate_COVID19_MB_first_second_vaccine_dose <- max(phac_covid_vaccine_mb_current$date)

phac_covid_vaccine_mb_current_last_date_row <- phac_covid_vaccine_mb_current %>% filter(date == max(date))



cnt_first_dose <- phac_covid_vaccine_mb_current_last_date_row$cumulative_first_doses
pct_first_dose <- phac_covid_vaccine_mb_current_last_date_row$cumulative_first_doses / mb_12plus_population_2020estimate * 100

cnt_second_dose <- phac_covid_vaccine_mb_current_last_date_row$cumulative_second_doses
pct_second_dose <- phac_covid_vaccine_mb_current_last_date_row$cumulative_second_doses / mb_12plus_population_2020estimate * 100

subtitle_str <- paste(
  "Manitoba has administered ", comma(cnt_first_dose),
  " first doses of the COVID-19 vaccines, partially immunizing ",
  round(pct_first_dose, digits=1), " per cent of the population. ",
  comma(cnt_second_dose), " second doses have been administered, fully immunizing ",
  format(pct_second_dose, digits=2),
  " per cent of the population. ",
  sep=""
)


phac_covid_vaccine_7day_avg <- phac_covid_vaccine_mb_current %>%
  mutate(
    daily_7day_avg=round(roll_mean(first_doses, 7, na.rm=TRUE, fill=NA, align="right"))
  ) %>%
  arrange(date)

phac_covid_vaccine_7day_avg_doses <- phac_covid_vaccine_7day_avg %>%
  filter(date==max(date)) %>%
  select(daily_7day_avg) %>%
  pull()


# Projections DF
phac_covid_vaccine_mb_projected <- data.frame(
  date=seq(as.Date(maxdate_COVID19_MB_first_second_vaccine_dose + 1),
           as.Date("2021-12-31"),
           by="1 day"
  )
) %>%
  mutate(
    first_doses=0,
    second_doses=0,
    total_doses=0,
    cumulative_first_doses=0,
    cumulative_second_doses=0,
    cumulative_total_doses=0,
    daily_doses_7dayavg_projected=phac_covid_vaccine_7day_avg_doses,
    daily_doses_5K_projected=5000,
    daily_doses_10K_projected=10000,
    daily_doses_12K_projected=12000,
    daily_doses_20K_projected=20000,
    cumsum_daily_doses_7dayavg_projected=0,
    cumsum_daily_doses_5K_projected=0,
    cumsum_daily_doses_10K_projected=0,
    cumsum_daily_doses_12K_projected=0,
    cumsum_daily_doses_20K_projected=0
  )


phac_covid_vaccine_mb_projections <- rbind(
  phac_covid_vaccine_mb_current,
  phac_covid_vaccine_mb_projected
) %>%
  arrange(date) %>%
  mutate(
    daily_doses_10K_projected=ifelse(date > as.Date("2021-04-01"), 10000, daily_doses_10K_projected),
    daily_doses_12K_projected=ifelse(date > as.Date("2021-04-01"), 12000, daily_doses_12K_projected),
    daily_doses_20K_projected=ifelse(date > as.Date("2021-04-01"), 20000, daily_doses_20K_projected)
  ) %>%
  mutate(
    cumsum_daily_doses_7dayavg_projected=cumsum(daily_doses_7dayavg_projected),
    cumsum_daily_doses_5K_projected=cumsum(daily_doses_5K_projected),
    cumsum_daily_doses_10K_projected=cumsum(daily_doses_10K_projected),
    cumsum_daily_doses_12K_projected=cumsum(daily_doses_12K_projected),
    cumsum_daily_doses_20K_projected=cumsum(daily_doses_20K_projected)
  ) %>%
  filter(date <= as.Date("2021-08-01"))

