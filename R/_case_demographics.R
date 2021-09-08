
start <- as.Date("2020-09-14",format="%Y-%m-%d")
end <- as.Date("2021-08-16",format="%Y-%m-%d")
importJSON <- "None" # None/Full

# THIS TAKES A FEW MINUTES, READ THE CSV UNLESS IT'S THE FIRST RUN OF THE DAY
# Create df based on what the JSON contains then rbind in the while loop

# Pull from JSON and stack the dates
# Oct 4 and 10 are wrong in this b/c column names
# change halfway through the month

if(importJSON == "Full"){

  theDate <- start

  demographics_df_sample <- jsonlite::fromJSON(dir_data_raw( "demographic_heatmap/2020-10-01-demographics-rha.json"))
  demographics_df_sample <- demographics_df_sample[["features"]][["attributes"]]
  demographics_df_sample <- demographics_df_sample %>%
    clean_names() %>%
    mutate(
      date = as.Date("2020-10-01", "%Y-%m-%d"),
      total_cases = NA,
      object_id = NA
    )
  demographics_df <- slice(demographics_df_sample, 0)
  # demographics_df <- demographics_df

  while (theDate <= end){

    file_name <- paste("/demographic_heatmap/", format(theDate,"%Y-%m-%d"), "-demographics-rha.json", sep="")
    print(file_name)

    if(file.exists(dir_data_raw(file_name))){
      demographics_rha_tmp <- jsonlite::fromJSON(dir_data_raw(file_name))

      # demographics_rha_tmp <- jsonlite::fromJSON(here::here(dir_data_raw, file_name))
      demographics_rha_tmp <- demographics_rha_tmp[["features"]][["attributes"]]
      demographics_rha_tmp <- demographics_rha_tmp %>%
        clean_names() %>%
        mutate(
          date = as.Date(theDate, "%Y-%m-%d")
        )

      if("total_cases" %in% colnames(demographics_rha_tmp)){
        demographics_rha_tmp <- demographics_rha_tmp %>% rename( value = total_cases )
      }

      if("object_id" %in% colnames(demographics_rha_tmp)){
        demographics_rha_tmp <- demographics_rha_tmp %>% select(-object_id)
      }

      demographics_df <- rbind(demographics_df, demographics_rha_tmp)

      Sys.sleep(.25)

    }

    theDate <- theDate + 1

  }

  write_csv(demographics_df, dir_data_out(paste("demographics_df", '.csv', sep='')))

}

dashboard_demographics <- read_csv(dir_data_out("demographics_df.csv"))

MB_pop_estimates_2020 <- MB_pop_estimates_2020_statcan_17_10_0005_01 %>%
  group_by(age_group_mb) %>%
  summarize(total = sum(population_2020est)) %>%
  mutate(
    age_group_mb = ifelse(age_group_mb == "100+", "99+", age_group_mb)
  )

dashboard_demographics_allrha <- read_csv(dir_data_out("demographics_df.csv")) %>%
  filter(rha == "All") %>%
  select(-rha) %>%
  pivot_wider(names_from = gender, values_from = value) %>%
  clean_names() %>%
  mutate(
    total_cases = male + female
  ) %>%
  select(
    -female, -male
  ) %>%
  pivot_wider(
    names_from="age_group",
    names_prefix = "age_",
    values_from="total_cases"
  ) %>%
  clean_names() %>%
  mutate(
    epi_week = epiweek(date),
    epi_year = epiyear(date),
    epi_year_week = paste(epi_year, "_", epi_week, sep="")
  )

dashboard_demographics_allrha$total_cases_todate <- rowSums(dashboard_demographics_allrha[ , c(2:12)], na.rm=TRUE)

dashboard_demographics_allrha <- dashboard_demographics_allrha %>%
  arrange(date) %>%
  mutate(
    new_cases_daily_total = total_cases_todate - lag(total_cases_todate),
    new_cases_age_99 = age_99 - lag(age_99),
    new_cases_age_90_99 = age_90_99 - lag(age_90_99),
    new_cases_age_80_89 = age_80_89 - lag(age_80_89),
    new_cases_age_70_79 = age_70_79 - lag(age_70_79),
    new_cases_age_60_69 = age_60_69 - lag(age_60_69),
    new_cases_age_50_59 = age_50_59 - lag(age_50_59),
    new_cases_age_40_49 = age_40_49 - lag(age_40_49),
    new_cases_age_30_39 = age_30_39 - lag(age_30_39),
    new_cases_age_20_29 = age_20_29 - lag(age_20_29),
    new_cases_age_10_19 = age_10_19 - lag(age_10_19),
    new_cases_age_0_9 = age_0_9 - lag(age_0_9)
  )

write_csv(dashboard_demographics_allrha, dir_data_processed('dashboard_demographics_allrha.csv'))


dashboard_demographics_allrha_new_weekly_byage <- dashboard_demographics_allrha %>%
  select(epi_week, epi_year, epi_year_week, new_cases_daily_total,
         new_cases_age_99, new_cases_age_90_99, new_cases_age_80_89, new_cases_age_70_79,
         new_cases_age_60_69, new_cases_age_50_59, new_cases_age_40_49,
         new_cases_age_30_39, new_cases_age_20_29, new_cases_age_10_19, new_cases_age_0_9
         )

dashboard_demographics_allrha_new_weekly_byage_all <- dashboard_demographics_allrha_new_weekly_byage %>%
  select(epi_week, epi_year, epi_year_week, new_cases_daily_total) %>%
  group_by(epi_year_week) %>%
  summarize(new_weekly_cases_allages = sum(new_cases_daily_total, na.rm=TRUE))

dashboard_demographics_allrha_new_weekly_byages <- dashboard_demographics_allrha_new_weekly_byage %>%
  select(epi_year_week,
         new_cases_age_99, new_cases_age_90_99, new_cases_age_80_89, new_cases_age_70_79, new_cases_age_60_69,
         new_cases_age_50_59, new_cases_age_40_49, new_cases_age_30_39, new_cases_age_20_29, new_cases_age_10_19, new_cases_age_0_9
         ) %>%
  pivot_longer(-epi_year_week,
               names_to="age_group",
               values_to="new_cases") %>%
  group_by(epi_year_week, age_group) %>%
  summarize(new_weekly_cases = sum(new_cases, na.rm=TRUE))

#

dashboard_demographics_allrha_new_weekly_cases_cnt <- left_join(
  dashboard_demographics_allrha_new_weekly_byages,
  dashboard_demographics_allrha_new_weekly_byage_all,
) %>%
  mutate(
    percentage_weekly_cases = format(new_weekly_cases / new_weekly_cases_allages * 100, digits=2),
    age_group = gsub("new_cases_age_", "", age_group),
    age_group = gsub("_", "-", age_group)
  ) %>%
  select(
    -new_weekly_cases_allages,
    -percentage_weekly_cases
  ) %>%
  pivot_wider(names_from = age_group, values_from = new_weekly_cases, names_prefix="cases_age_") %>%
  mutate(
    epi_year_week2 = epi_year_week
  ) %>%
  separate(epi_year_week, c("yr", "wk"))


dashboard_demographics_allrha_new_weekly_cases_pct <- left_join(
  dashboard_demographics_allrha_new_weekly_byages,
  dashboard_demographics_allrha_new_weekly_byage_all,
) %>%
  mutate(
    percentage_weekly_cases = format(new_weekly_cases / new_weekly_cases_allages * 100, digits=2),
    age_group = gsub("new_cases_age_", "", age_group),
    age_group = gsub("_", "-", age_group)
  ) %>%
  select(
    -new_weekly_cases_allages,
    -new_weekly_cases
  ) %>%
  pivot_wider(names_from = age_group, values_from = percentage_weekly_cases, names_prefix="pct_age_") %>%
  mutate(
    epi_year_week2 = epi_year_week
  ) %>%
  separate(epi_year_week, c("yr", "wk"))


dashboard_demographics_allrha_new_weekly_cases_cnt_pct <- left_join(
  dashboard_demographics_allrha_new_weekly_cases_cnt,
  dashboard_demographics_allrha_new_weekly_cases_pct
)

write_csv(dashboard_demographics_allrha_new_weekly_cases_cnt_pct, dir_data_out(paste("dashboard_demographics_allrha_new_weekly_cases_cnt_pct", '.csv', sep='')))




# Q&D plot
demographics_allrha_new_weekly_cases_pct_2 <- dashboard_demographics_allrha_new_weekly_cases_pct %>%
  select(-yr, -wk) %>%
  rename(epi_year_week = epi_year_week2) %>%
  pivot_longer(-epi_year_week,
               names_to="age_group",
               values_to="pct_weekly_cases") %>%
  mutate(
    age_group = gsub("pct_age_", "", age_group),
    age_group = ifelse(age_group == "99", "99 plus", age_group)
  ) %>%
  separate(epi_year_week, c("yr", "wk")) %>%

  mutate(
    yr = as.numeric(as.character(yr)),
    wk = as.numeric(as.character(wk)),
    week_of = MMWRweek::MMWRweek2Date(MMWRyear = yr,
                                      MMWRweek = wk,
                                      MMWRday = 2)
  )

p_demographics_allrha_new_weekly_cases_pct <-   ggplot(demographics_allrha_new_weekly_cases_pct_2) +
  aes(x=week_of, y=pct_weekly_cases, group=age_group) +
  geom_line(size=1, colour="#999999") +
  geom_line(data=demographics_allrha_new_weekly_cases_pct_2 %>% filter(age_group == "0-9"),
            size=1, colour=wfp_blue)


