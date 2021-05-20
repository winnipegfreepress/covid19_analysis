
covid_mb_occupations <- read_csv("data/raw/covid_mb_occupations.csv") %>%
  clean_names() %>%
  mutate(
    job_sector = factor(job_sector)
  )

p_covid_mb_occupations <- bar_plot_xy_reorder(
  covid_mb_occupations,
  x_var=job_sector, y_var=pct_cases,
  title_str="Percentage of COVID-19 cases by reported occupation category",
  subtitle_str="Sample of 234 cases reported between May 1-Dec. 31, 2020",
  x_str="", y_str="", y_units="%", ymin=0, ymax=100,
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

# p_covid_mb_occupations <- p_covid_mb_occupations +
#   geom_text(
#     data=covid_mb_occupations,
#     aes(x=job_sector, y=pct_cases, label=pct_cases),
#     size=3.5
#   )

wfp_covid_mb_occupations <- prepare_plot(p_covid_mb_occupations)
ggsave_pngpdf(wfp_covid_mb_occupations, "wfp_covid_mb_occupations", width_var=8.66, height_var=6, dpi_var=96, scale_var=1, units_var="in")
