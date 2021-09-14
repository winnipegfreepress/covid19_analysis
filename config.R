# =================================================================
# This file configures the project by specifying filenames, loading
# packages and setting up some project-specific variables.
# =================================================================

# This initializes your startr project
initialize_startr(
  title = "covid19_analysis",
  author = "Michael Pereira <monkeycycle@gmail.com>",
  timezone = "America/Winnipeg",
  should_render_notebook = TRUE,
  should_process_data = TRUE,
  should_timestamp_output_files = TRUE,
  should_beep = FALSE,
  packages = c(
    "devtools",
    "tidyverse", "glue", "magrittr",
    "lubridate", "hms",
    "readxl", "feather", "RcppRoll",
    "scales", "janitor", "httr",
    # "Cairo",
    "ggrepel", "prettydoc",
    "aws.s3", "dotenv", "rlang",
    "googledrive", "googlesheets4", "cowplot",
    "zip", "gmailr", "knitr", "DT", "zoo", "ggtext",
    "ggpubr", "ggtext", "showtext", "kableExtra",
    "gmailr", "patchwork",
    "pracma", "ISOweek", "easycsv"
    # "EpiWeek",
    # "slackr"
    # "sendmailR",
    # "emayili",
    # "RcmdrPlugin.KMggplot2"
    # "rvest",
    # "tidymodels",
    # "gganimate",
    # "sf",
    # "cansim",
    # "cancensus",
  )
)


install_github("chrismerkord/epical")
library(epical)

# Misc vars and strings
source(dir_src("theme.R"))
source(dir_src("palette.R"))
credit_str = "WINNIPEG FREE PRESS"
time_pause <- .5
font_add_google("Open Sans")

last_update_timestamp=Sys.Date()



