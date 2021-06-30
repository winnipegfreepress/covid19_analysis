if (!require("upstartr")) install.packages("upstartr")
library("upstartr")
run_config()


################################################################################
# Grab and cache latest data from
# Google Sheets and various dahsboards.
# This takes a few minutes to run.
################################################################################
source(dir_src("get.R"))


################################################################################
# Process new data to prepare for analysis
################################################################################
run_process()


################################################################################
# Run analysis steps
################################################################################
run_analyze()


# Get the initial graphic and tweet ready
source(dir_src("visualize_strings.R"))
source(dir_src("visualize_daily_case_status.R"))
source(dir_src("tweets.R"))


run_visualize()
upload_plots_s3()

