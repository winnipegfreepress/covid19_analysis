
library(readr)
WFP_provincial_vax_pct_100K_provincial_vax_pct_100K <- read_csv("data/raw/WFP - provincial_vax_pct_100K - provincial_vax_pct_100K.csv") %>%
  clean_names()

View(WFP_provincial_vax_pct_100K_provincial_vax_pct_100K)


p_vaccine_1st_pct_provs <- plot_bar_x_reordered_y(
  WFP_provincial_vax_pct_100K_provincial_vax_pct_100K %>% filter(province != "Québec"),
  x_var=province, y_var=atleast1_pct,
  bar_colour=nominalMuted_shade_0,
  # colour_var=rha, fill_var=rha, group_var=rha,
  title_str="Percentage of people who have received one dose of a COVID-19 vaccine in Canada",
  # subtitle_str="All deaths reported per 100,000 people", x_str="", y_str="",
  y_units="", ymin=0, ymax=100,
  source_str="COVID-19 Canada Open Data Working Group", lastupdate_str=last_update_timestamp
)

p_vaccine_1st_pct_provs <- p_vaccine_1st_pct_provs +
  geom_col(
    data=WFP_provincial_vax_pct_100K_provincial_vax_pct_100K %>% filter(province == "Manitoba"),
    aes(x=reorder(province, atleast1_pct), y=atleast1_pct),
    colour=wfp_blue, fill=wfp_blue, size=.05
  ) +
  geom_text(
    data=WFP_provincial_vax_pct_100K_provincial_vax_pct_100K %>% filter(province != "Québec"),
    aes(x=province, y=atleast1_pct,
        label=round(atleast1_pct, digits=0)
    ),
    color="#000000", hjust=-.25, vjust=.45, size=4
  ) +
  scale_y_continuous(
    expand=c(0, 0),
    limits=c(0, 100),
    labels=function(x) {
      ifelse(x == 100, paste(x, "%", sep=""), x)
    }
  ) +
  theme(
    axis.title=ggplot2::element_text(size=10, color="#222222"),
    axis.text=ggplot2::element_text(size=10, color="#222222"),
    axis.text.x=ggplot2::element_text(size=10, color="#222222"),
    axis.text.y=ggplot2::element_text(size=10, color="#222222"),
    # axis.line=ggplot2::element_blank(),
    # # axis.line.x=ggplot2::element_line(color="#777777"),
    # axis.line.y=ggplot2::element_blank(),
    axis.ticks=ggplot2::element_line(color="#888888")
  )


wfp_vaccine_1st_pct_provs <- prepare_plot(p_vaccine_1st_pct_provs)
ggsave_pngpdf(wfp_vaccine_1st_pct_provs, "wfp_vaccine_1st_pct_provs", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in")

