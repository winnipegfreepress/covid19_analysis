if (!require("upstartr")) install.packages("upstartr")
library("upstartr")
run_config()


################################################################################
# Grab and cache latest data from Google Sheets and various dahsboards.
# This can take a few minutes to run.
################################################################################
source(dir_src("get.R"))


################################################################################
# Process new data to prepare for analysis
################################################################################
run_process()

cat("All done. That's it! \n\n")
