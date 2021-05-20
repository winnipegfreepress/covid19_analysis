
############################################################
# Healthcare workers
# -- source is weekly epidemiology report
############################################################
gsheet_wfp_healthcareworkers <- read_csv(dir_data_raw("gsheet_wfp_healthcareworkers.csv")) %>%
  clean_names() %>%
  mutate( week_of=as.Date(week_of, "%m/%d/%Y") ) %>%
  select( -note_other_is_sum_of_all_other_hcw_categories_social_worker_etc_which_has_changed_over_time )
write_feather(gsheet_wfp_healthcareworkers, dir_data_processed("gsheet_wfp_healthcareworkers.feather"))
write_csv(gsheet_wfp_healthcareworkers, dir_data_processed('gsheet_wfp_healthcareworkers.csv'))

gsheet_wfp_healthcareworkers_tall <- gsheet_wfp_healthcareworkers %>%
  pivot_longer(
    cols=c(
      nurse,
      physician_physician_in_training,
      allied_health_professional,
      first_responder,
      not_identified,
      health_care_aide,
      other
    ),
    names_to="hcw_role",
    values_to="count"
  ) %>%
  mutate(
    hcw_role=case_when(
      hcw_role == "nurse" ~ "Nurse",
      hcw_role == "physician_physician_in_training" ~ "Physician/Physician in training",
      hcw_role == "allied_health_professional" ~ "Allied health professional",
      hcw_role == "first_responder" ~ "First responder",
      hcw_role == "not_identified" ~ "Not identified",
      hcw_role == "health_care_aide" ~ "Health care aide",
      hcw_role == "other" ~ "Other"
    )
  ) %>%
  filter(hcw_role != "Other")

write_feather(gsheet_wfp_healthcareworkers_tall, dir_data_processed("gsheet_wfp_healthcareworkers_tall.feather"))
write_csv(gsheet_wfp_healthcareworkers_tall, dir_data_processed('gsheet_wfp_healthcareworkers_tall.csv'))

############################################################
# COVID-19 transmission source
# -- source is weekly epidemiology report
############################################################
gsheet_wfp_transmission_source <- read_csv(dir_data_raw("gsheet_wfp_transmission_source.csv")) %>%
  clean_names() %>%
  mutate( week_of=as.Date(week_of, "%m/%d/%Y") )

write_feather(gsheet_wfp_transmission_source, dir_data_processed("gsheet_wfp_transmission_source.feather"))
write_csv(gsheet_wfp_transmission_source, dir_data_processed('gsheet_wfp_transmission_source.csv'))

gsheet_wfp_transmission_source_tall <- gsheet_wfp_transmission_source %>%
  pivot_longer(
    cols=c(
      unknown,
      travel,
      close_contact,
      investigation_pending,
    ),
    names_to="transmission_source",
    values_to="count"
  ) %>%
  mutate(
    transmission_source=case_when(
      transmission_source == "unknown" ~ "Unknown",
      transmission_source == "travel" ~ "Travel",
      transmission_source == "close_contact" ~ "Close contact",
      transmission_source == "investigation_pending" ~ "Investigation pending"
    )
  )
write_feather(gsheet_wfp_transmission_source_tall, dir_data_processed("gsheet_wfp_transmission_source_tall.feather"))
write_csv(gsheet_wfp_transmission_source_tall, dir_data_processed('gsheet_wfp_transmission_source_tall.csv'))


############################################################
# COVID-19 symptoms
# -- source is weekly epidemiology report
############################################################
gsheet_wfp_symptoms <- read_csv(dir_data_raw("gsheet_wfp_symptoms.csv")) %>%
  clean_names() %>%
  mutate( week_of=as.Date(week_of, "%m/%d/%Y") )

write_feather(gsheet_wfp_symptoms, dir_data_processed("gsheet_wfp_symptoms.feather"))
write_csv(gsheet_wfp_symptoms, dir_data_processed('gsheet_wfp_symptoms.csv'))

gsheet_wfp_symptoms_tall <- gsheet_wfp_symptoms %>%
  pivot_longer(
    cols=c(
      symptomatic,
      asymptomatic,
      cough,
      headache,
      fever,
      muscle_pain,
      chills,
      sore_throat
    ),
    names_to="symptom",
    values_to="count"
  ) %>%
  mutate(
    symptom=case_when(
      symptom == "symptomatic" ~ "Symptomatic",
      symptom == "asymptomatic" ~ "Asymptomatic",
      symptom == "cough" ~ "Cough",
      symptom == "headache" ~ "Headache",
      symptom == "fever" ~ "Fever",
      symptom == "muscle_pain" ~ "Muscle pain",
      symptom == "chills" ~ "Chills",
      symptom == "sore_throat" ~ "Sore throat"
    )
  )
write_feather(gsheet_wfp_symptoms_tall, dir_data_processed("gsheet_wfp_symptoms_tall.feather"))
write_csv(gsheet_wfp_symptoms_tall, dir_data_processed('gsheet_wfp_symptoms_tall.csv'))
