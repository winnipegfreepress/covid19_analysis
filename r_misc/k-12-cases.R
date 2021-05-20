
library(readr)
K_12CasesByWeek <- read_csv("data/raw/K-12CasesByWeek.csv") %>%
  clean_names() %>%
  mutate(
    date = as.Date(date_announced, format = "%B %d, %Y"),
    month = month(date)
  )
# View(K_12CasesByWeek)

K_12CasesByWeek_2nd <- K_12CasesByWeek %>%
  filter(month == 10)

K_12CasesByWeek_2nd <- K_12CasesByWeek %>%
  filter(month == 10)

K_12CasesByWeek_3rd <- K_12CasesByWeek %>%
  filter(date >= as.Date("2021-04-19") - 31)

total_K_12CasesByWeek_2nd <- sum(K_12CasesByWeek_2nd$sum_of_k_12_cases, na.rm=TRUE)
total_K_12CasesByWeek_3rd <- sum(K_12CasesByWeek_3rd$sum_of_k_12_cases, na.rm=TRUE)

p_k_12_tracked_cases <- ggplot(K_12CasesByWeek) +
  aes(x = date, y = sum_of_k_12_cases) +
  geom_bar(stat="identity", colour = "#e9e9e9", fill = "#e9e9e9") +
  geom_bar(data=K_12CasesByWeek_2nd,
           stat="identity", colour = wfp_blue, fill = wfp_blue, size=.5) +
  geom_bar(data=K_12CasesByWeek_3rd,
           stat="identity", colour = wfp_blue, fill = wfp_blue, size=.5) +

  annotate("text",
           x = as.Date("2020-10-05"),
           y = 35,
           label = paste(comma(total_K_12CasesByWeek_2nd), "\nK-12 cases", sep = ""),
           vjust = 0.8, size = 4, lineheight = 1,
           colour = "#000000"
  ) +

  geom_curve(
    data = data.frame(
      x = as.Date("2020-10-05"), y = 28,
      xend = as.Date("2020-10-20"), yend = 18
    ),
    mapping = aes(x = x, y = y, xend = xend, yend = yend),
    size = .25, colour = "#000000", curvature = .25, arrow = structure(list(angle = 30, length = structure(0.1, class = "unit", valid.unit = 2L, unit = "inches"), ends = 2L, type = 2L), class = "arrow"), inherit.aes = FALSE, show.legend = FALSE
  ) +


  annotate("text",
           x = as.Date("2021-03-20"),
           y = 50,
           label = paste(comma(total_K_12CasesByWeek_3rd), "\nK-12 cases", sep = ""),
           vjust = 0.8, size = 4, lineheight = 1,
           colour = "#000000"
  ) +

  geom_curve(
    data = data.frame(
      x = as.Date("2021-03-25"), y = 42,
      xend = as.Date("2021-04-10"), yend = 28
    ),
    mapping = aes(x = x, y = y, xend = xend, yend = yend),
    size = .25, colour = "#000000", curvature = .25, arrow = structure(list(angle = 30, length = structure(0.1, class = "unit", valid.unit = 2L, unit = "inches"), ends = 2L, type = 2L), class = "arrow"), inherit.aes = FALSE, show.legend = FALSE
  ) +

  scale_x_date(
    expand = c(0, 0),
    limits = c(as.Date("2020-09-01"), as.Date("2021-06-30")),
    date_breaks = "1 month",
    labels = date_format("%b")
  ) +
  scale_y_continuous(
    expand = c(0, 0),
    limits = c(0, 80),
    labels = scales::comma
  ) +
  labs(
    title = wrap_text("Reported cases of COVID-19 in K-12 settings in Manitoba", 70),
    subtitle = wrap_text("Provincial reporting of school cases changed to twice weekly in 2021", 80),
    caption = wrap_text(toupper(paste("WINNIPEG FREE PRESS — SOURCE: COVIDSchoolCasesMB (", last_update_timestamp, ")", sep = "")), 80),
    x = "",
    y = "",
    fill = ""
  ) +
  minimal_theme()


wfp_k_12_tracked_cases <- prepare_plot(p_k_12_tracked_cases)
ggsave_pngpdf(wfp_k_12_tracked_cases, "wfp_k_12_tracked_cases", width_var = 8.66, height_var = 6, dpi_var=96, scale_var = 1, units_var = "in")

plot(p_k_12_tracked_cases)
