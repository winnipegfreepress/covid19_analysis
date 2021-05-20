
font_add_google("Open Sans")
showtext_auto()

date_current=max(wfp_covid19_topline$date)
date_min_90days=date_current - 90
date_min_60days=date_current - 60
date_min_30days=date_current - 30
date_max=date_current
date_max_15 <- date_max + 15

latest_daily_cases <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(new_daily_cases) %>% pull()
latest_daily_deaths <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(new_daily_deaths) %>% pull()

cumsum_cases <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(confirmed_and_probable) %>% pull()
cumsum_deaths <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(deaths) %>% pull()

latest_14day_cases_sum <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(cases_14day_sum) %>% pull()
latest_14day_cases_pct_chg <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(cases_14day_pctchg) %>% pull()

latest_14day_deaths_sum <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(deaths_14day_sum) %>% pull()
latest_14day_deaths_pct_chg <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(deaths_14day_pctchg) %>% pull()

latest_14day_doses_first_sum <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(doses_first_14day_sum) %>% pull()
latest_14day_doses_first_pct_chg <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(doses_first_14day_pctchg) %>% pull()

latest_cumulative_first_doses <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(cumulative_first_doses) %>% pull()
latest_cumulative_first_doses_per_100K <- wfp_covid19_topline %>% filter(date==max(date)) %>% select(cumulative_first_doses_per_100K) %>% pull()

# Q&D percentage of eligible population vaccinated
latest_cumulative_first_dose_vaccinations=round(latest_cumulative_first_doses_per_100K / 1000, digits=1)

################################################################################
# Strings
################################################################################

p_title <- paste("COVID-19 in Manitoba")
p_title.p <- ggparagraph(text=p_title, face="bold", size=14, lineheight=1, color="black", margin(0,0.2,0,0.2, "cm"))

p_title_vaccinations <-
# p_title_vaccinations.p <- ggparagraph(text = paste("Vaccinations"), face = "bold", size = 12, lineheight = 1, color = "black", margin(0, 0.2, 0, 0.2, "cm"))
p_title_vaccinations.p <- ggparagraph(text = paste("Vaccinations ==", "", sep=""), size = 12, lineheight = 1, color = "black", margin(0.2, 0.2, 0, 0.2, "cm"))

p_credit=toupper(credit_str)
p_credit.p=ggparagraph(text=p_credit, size=7, color="black",  margin(0.2,0.2,0,0.2, "cm"))

p_source=toupper(paste("SOURCE: ", "Manitoba Health",sep=""))
p_source.p=ggparagraph(text=p_source, size=7, color="black",  margin(0.2,0.2,0,0.2, "cm"))

p_credit_source=paste("SOURCE: MANITOBA HEALTH", " (", format(date_max, "%Y-%m-%d"), ")", sep="")
# p_credit_source.p=ggparagraph(text=p_credit_source, size=6, color="black",  margin(0.2,0,0,0, "cm"))
p_credit_source.p <- text_grob(
  x=0,
  y=0,
  label=p_credit_source,
  # just="left",
  hjust=0,
  vjust=0,
  color="black",
  face="plain",
  size=7,
  lineheight=1
)

# dumbdf <-  data.frame()
# p_credit_source.p=ggtext(data=dumbdf, x=0, y=0, label=p_credit_source, size=6, color="black", hjust=.5)

latest_14day_cases_pct_chg_str <- ""
latest_14day_cases_pct_chg_sym <- ""
if(latest_14day_cases_pct_chg > 0){
  latest_14day_cases_pct_chg_sym="\u25B2" #"▲"
  latest_14day_cases_pct_chg_sym_colour=nominalBold_shade_1
  latest_14day_cases_pct_chg_str=paste("14 day increase", sep="")
}

if(latest_14day_cases_pct_chg < 0){
  latest_14day_cases_pct_chg_sym="▼" #"\u25BC"
  latest_14day_cases_pct_chg_sym_colour=nominalBold_shade_0
  latest_14day_cases_pct_chg_str=paste("14 day decrease", sep="")
}

if(latest_14day_cases_pct_chg == 0){
  latest_14day_cases_pct_chg_sym="" #"\u25BC"
  latest_14day_cases_pct_chg_sym_colour="#989898"
  latest_14day_cases_pct_chg_str=paste("no change", sep="")
}

latest_14day_deaths_pct_chg_sym=""
latest_14day_deaths_pct_chg_str=""
latest_14day_deaths_pct_chg_str <- ""
if(latest_14day_deaths_pct_chg > 0){
  latest_14day_deaths_pct_chg_sym="▲" #"\u25B2"
  latest_14day_deaths_pct_chg_sym_colour=nominalBold_shade_1
  latest_14day_deaths_pct_chg_str=paste("14 day increase", sep="")
}

if(latest_14day_deaths_pct_chg < 0){
  latest_14day_deaths_pct_chg_sym="▼" #"\u25BC"
  latest_14day_deaths_pct_chg_sym_colour=nominalBold_shade_0
  latest_14day_deaths_pct_chg_str=paste("14 day decrease", sep="")
}

if(latest_14day_deaths_pct_chg == 0){
  latest_14day_deaths_pct_chg_sym="" #"\u25BC"
  latest_14day_deaths_pct_chg_sym_colour="#989898"
  latest_14day_deaths_pct_chg_str=paste("no change", sep="")
}


latest_14day_doses_first_pct_chg_sym=""
latest_14day_doses_first_pct_chg_str=""
if(latest_14day_doses_first_pct_chg > 0){
  latest_14day_doses_first_pct_chg_sym="▲" #"\u25B2"
  latest_14day_doses_first_pct_chg_sym_colour=nominalBold_shade_1
  latest_14day_doses_first_pct_chg_str=paste("14 day increase", sep="")
}

if(latest_14day_doses_first_pct_chg < 0){
  latest_14day_doses_first_pct_chg_sym="▼" #"\u25BC"
  latest_14day_doses_first_pct_chg_sym_colour=nominalBold_shade_0
  latest_14day_doses_first_pct_chg_str=paste("14 day decrease", sep="")
}

if(latest_14day_doses_first_pct_chg == 0){
  latest_14day_doses_first_pct_chg_sym="" #"\u25BC"
  latest_14day_doses_first_pct_chg_sym_colour="#989898"
  latest_14day_doses_first_pct_chg_str=paste("no change", sep="")
}

