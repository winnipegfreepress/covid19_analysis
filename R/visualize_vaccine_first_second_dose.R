
cumulative_total_doses_cnt <- cumulative_first_doses_cnt + cumulative_second_doses_cnt

p_covid_19_mb_vaccinations_first_second <- plot_line_timeseries(
  COVID19_MB_first_second_vaccine_dose,
  x_var=vaccination_date,
  y_var=cumulative_first_doses,
  line_colour=nominalMuted_shade_0,
  title_str="First and second dose vaccinations for COVID-19 in Manitoba",
  subtitle_str="Total vaccinations to date",
  x_str="", y_str="",
  xmin="2020-12-01", xmax=xmax_var, xformat="%b", x_units="3 months",
  ymin=0, ymax=1500000, y_units="%",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)


p_covid_19_mb_vaccinations_first_second <- p_covid_19_mb_vaccinations_first_second +
  geom_line(aes(x=vaccination_date, y=cumulative_second_doses),
            size = 1, colour = nominalMuted_shade_1)

# cumsum to date 1st dose
p_covid_19_mb_vaccinations_first_second <- p_covid_19_mb_vaccinations_first_second +
  geom_point(data=COVID19_MB_first_second_vaccine_dose %>% filter(vaccination_date == max(vaccination_date)),
             aes(x=vaccination_date, y=cumulative_first_doses),
             color=nominalBold_shade_0, fill=nominalBold_shade_0, size=1.5, alpha=1
  ) +
  geom_text(data=COVID19_MB_first_second_vaccine_dose %>% filter(vaccination_date == max(vaccination_date)),
            aes(x=vaccination_date + 5, y=cumulative_first_doses, label=paste(comma(cumulative_first_doses), "\n", "first doses", sep="")),
            color="#000000", hjust=.05, vjust=-.5, size=4
  )

# cumsum to date 2nd dose
p_covid_19_mb_vaccinations_first_second <- p_covid_19_mb_vaccinations_first_second +
  geom_point(data=COVID19_MB_first_second_vaccine_dose %>% filter(vaccination_date == max(vaccination_date)),
             aes(x=vaccination_date, y=cumulative_second_doses),
             color=nominalBold_shade_1, fill=nominalBold_shade_1, size=1.5, alpha=1
  ) +
  geom_text(data=COVID19_MB_first_second_vaccine_dose %>% filter(vaccination_date == max(vaccination_date)),
            aes(x=vaccination_date + 5, y=cumulative_second_doses, label=paste(comma(cumulative_second_doses), "\n", "second doses", sep="")),
            color="#000000", hjust=.05, vjust=1.5, size=4
  )



wfp_covid_19_mb_vaccinations_first_second <- prepare_plot(p_covid_19_mb_vaccinations_first_second)

ggsave_pngpdf(wfp_covid_19_mb_vaccinations_first_second, "wfp_covid_19_mb_vaccinations_first_second", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")
ggsave_pngpdf(wfp_covid_19_mb_vaccinations_first_second, "wfp_vaccine_administration_mb", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")



plot(wfp_covid_19_mb_vaccinations_first_second)

