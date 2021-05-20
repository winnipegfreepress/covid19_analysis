max_date <-  max(COVID19_MB_vaccine_distribution$date)

COVID19_MB_vaccine_distribution_7day <- COVID19_MB_vaccine_distribution %>%
  mutate(
    dvaccine_existing=cumulative_dvaccine - dvaccine,
    date_province=paste(date, province, sep="____")
  ) %>%
  select(
    date_province, dvaccine, dvaccine_existing
  ) %>%
  pivot_longer(
    -date_province,
    names_to="type",
    values_to="cnt"
  ) %>%
  separate(date_province, c("date", "province"), sep="____") %>%
  mutate(
    date=as.Date(date)
  ) %>%
  filter(province=="Manitoba") %>%
  mutate(
    dist_7days=ifelse(date > max_date - 7, TRUE, FALSE),
    dist_14days=ifelse(date > max_date - 14, TRUE, FALSE),
    recent_doses=ifelse(dist_7days == TRUE, "recent_7day",
                    ifelse(dist_14days == TRUE, "recent_14day",
                          "distributed"))

  )



