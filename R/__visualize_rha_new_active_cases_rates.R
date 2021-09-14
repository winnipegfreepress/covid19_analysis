# Cases and active case rates by health region
# Use a shorter window of time
xmin_var = "2021-07-01"
xmax_var = "2021-09-14"

source(dir_src("visualize_topline_blocks_strings.R"))
source(dir_src("../r_misc/covid19_districts.R"))


districts_4thwave_df <- districts_df %>%
  filter(date >= "2021-07-01") %>%
  filter(rha != "All") %>%
  filter(rha != area_name) %>%
  filter(area_name != "Unknown District") %>%
  arrange(area_name, date) %>%
  group_by(area_name) %>%
  mutate(
    new_daily_cases_diff = value - lag(value)
  ) %>%
  filter(new_daily_cases_diff >= 0) %>%
  ungroup() %>%
  left_join(
    manitoba_health_districts_populations,
    by=c("rha"="rha", "area_name"="district")
  ) %>%
  mutate(
    new_cases_100K = (new_daily_cases_diff / pop_2019) * 100000
  )



p_districts_4thwave <- ggplot(districts_4thwave_df) +
  aes(
    x = date,
    y = new_daily_cases_diff,
    colour = rha,
    group = area_name
  ) +
  geom_line(
    aes(
      x = date,
      y = new_daily_cases_diff,
      group = area_name
    ),
    colour="#ececec",
    size = 0.5, alpha=.5) +

  geom_line(data=districts_4thwave_df %>% filter(rha=="Southern Health-Santé Sud"),
    aes(
      x = date,
      y = new_daily_cases_diff,
      group = area_name
    ),
    colour=wfp_blue,
    size = 0.5, alpha=.5) +

  scale_color_hue(direction = 1) +
  minimal_theme()


# plot(p_districts_4thwave)

p_districts_4thwave <- plot_line_timeseries(
  districts_4thwave_df,
  x_var=date,
  y_var=new_daily_cases_diff,
  group_var=area_name,
  line_colour=nominalMuted_shade_0,
  title_str="New daily cases of COVID-19 across health districts",
  subtitle_str="",
  x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%B", x_units="1 month",
  ymin=0, ymax=50, y_units="%",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)



p_rha_new_cases <- plot_line_timeseries(
  dashboard_daily_status_manitoba,
  x_var=date,
  y_var=daily_cases_7day,
  group_var=rha,
  line_colour=nominalMuted_shade_0,
  title_str="New daily cases of COVID-19 across health regions",
  subtitle_str="Seven-day moving average for new daily cases since July 1, 2021",
  x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%B", x_units="1 month",
  ymin=0, ymax=50, y_units="%",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_rha_new_cases <- p_rha_new_cases +
  geom_point(data=dashboard_daily_status_manitoba %>% filter(date == max(date)),
             aes(x=date, y=daily_cases_7day),
             color=nominalBold_shade_0, fill=nominalMuted_shade_1, size=1.5, alpha=1
  ) +
  geom_text(data=dashboard_daily_status_manitoba %>% filter(date == max(date)),
            aes(x=as.Date(xmin_var) + 4, y=48,
                label=paste(
                  comma(daily_cases_7day, accuracy=1), " new cases", "\n",
                  sep="")
            ),
            color="#000000", hjust=.05, vjust=1, size=3.5
  ) +
  theme(
    strip.background=ggplot2::element_blank(),
    strip.text=ggplot2::element_text(size =13, hjust=0, face="bold"),
    panel.border=ggplot2::element_blank()
  ) +
  facet_wrap(.~rha)



p_rha_new_cases_100K <- plot_line_timeseries(
  dashboard_daily_status_manitoba,
  x_var=date,
  y_var=daily_cases_7day_100K,
  group_var=rha,
  line_colour=nominalMuted_shade_0,
  title_str="New cases of COVID-19 per capita in Manitoba",
  subtitle_str="Seven-day moving average for new daily cases",
  x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="2 months",
  ymin=0, ymax=20,
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_rha_new_cases_100K <- p_rha_new_cases_100K +
  geom_point(data=dashboard_daily_status_manitoba %>% filter(date == max(date)),
             aes(x=date, y=daily_cases_7day_100K),
             color=nominalBold_shade_0, fill=nominalMuted_shade_1, size=1.5, alpha=1
  ) +
  geom_text(data=dashboard_daily_status_manitoba %>% filter(date == max(date)),
            aes(x=as.Date(xmin_var) + 4, y=18,
                label=paste(
                  comma(daily_cases_7day_100K), " new cases/100K",
                  # "\n",
                  # comma(active_cases, accuracy=1), " active", "\n",
                  # comma(daily_cases, accuracy=1), " new",
                  sep="")
            ),
            color="#000000", hjust=.05, vjust=1, size=3.5
  ) +
  theme(
    strip.background=ggplot2::element_blank(),
    strip.text=ggplot2::element_text(size =13, hjust=0, face="bold"),
    panel.border=ggplot2::element_blank()
  ) +
  facet_wrap(.~rha)


p_rha_active_cases_100K <- plot_line_timeseries(
  dashboard_daily_status_manitoba,
  x_var=date,
  y_var=active_cases_7day_100K,
  group_var=rha,
  line_colour=nominalMuted_shade_0,
  title_str="Active cases of COVID-19 per capita in Manitoba",
  subtitle_str="Due to a backlog in provincial tracking of recovered cases, active cases may be lower than reported.",
  x_str="", y_str="",
  xmin=xmin_var, xmax=xmax_var, xformat="%b", x_units="2 months",
  ymin=0, ymax=250, y_units="%",
  source_str="Manitoba Health", lastupdate_str=last_update_timestamp
)

p_rha_active_cases_100K <- p_rha_active_cases_100K +
  geom_point(data=dashboard_daily_status_manitoba %>% filter(date == max(date)),
             aes(x=date, y=active_cases_7day_100K),
             color=nominalBold_shade_0, fill=nominalMuted_shade_1, size=1.5, alpha=1
  ) +
  geom_text(data=dashboard_daily_status_manitoba %>% filter(date == max(date)),
            aes(x=as.Date(xmin_var) + 4, y=248,
                label=paste(
                  comma(active_cases_7day_100K), " active cases/100K",
                  # "\n",
                  # comma(active_cases, accuracy=1), " active", "\n",
                  # comma(daily_cases, accuracy=1), " new",
                  sep="")
            ),
            color="#000000", hjust=.05, vjust=1, size=3.5
  ) +
  theme(
    strip.background=ggplot2::element_blank(),
    strip.text=ggplot2::element_text(size =13, hjust=0, face="bold"),
    panel.border=ggplot2::element_blank()
  ) +
  facet_wrap(.~rha)


# Save out the files
wfp_rha_new_cases_100K <- prepare_plot(p_rha_new_cases_100K)
ggsave(dir_plots("wfp_rha_new_cases_100K.png"),
       plot=wfp_rha_new_cases_100K,
       width=8.66, height=6, units = "in", dpi = 300,
       scale=1, limitsize = TRUE
)

wfp_rha_new_cases <- prepare_plot(p_rha_new_cases)
ggsave(dir_plots("wfp_rha_new_cases.png"),
       plot=wfp_rha_new_cases,
       width=8.66, height=6, units = "in", dpi = 300,
       scale=1, limitsize = TRUE
)

wfp_rha_active_cases_100K <- prepare_plot(p_rha_active_cases_100K)
ggsave(dir_plots("wfp_rha_active_cases_100K.png"),
       plot=wfp_rha_active_cases_100K,
       width=8.66, height=6, units = "in", dpi = 300,
       scale=1, limitsize = TRUE
)


wfp_districts_4thwave <- prepare_plot(p_districts_4thwave)
ggsave(dir_plots("wfp_districts_4thwave.png"),
       plot=wfp_districts_4thwave,
       width=8.66, height=6, units = "in", dpi = 300,
       scale=1, limitsize = TRUE
)
