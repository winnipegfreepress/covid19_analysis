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
  packages = c(
    "tidyverse", "glue", "magrittr", "lubridate", "hms",
    "readxl", "feather", "RcppRoll",
    "scales", "janitor", "httr", "Cairo",
    "ggrepel", "prettydoc",
    "aws.s3", "dotenv", "rlang",
    "googledrive", "googlesheets4", "cowplot",
    "zip", "gmailr", "knitr", "DT", "zoo", "ggtext",
    "ggpubr", "ggtext", "showtext", "kableExtra",
    "pracma", "ISOweek"
    # "RcmdrPlugin.KMggplot2"
    # "rvest",
    # "tidymodels",
    # "gganimate",
    # "sf",
    # "cansim", "cancensus",
  )
)


# Misc vars and strings
credit_str = "WINNIPEG FREE PRESS"
time_pause <- .5
# font_add_google("Open Sans")
