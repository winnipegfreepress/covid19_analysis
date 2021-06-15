if (!require("upstartr")) install.packages("upstartr")
library("upstartr")
run_config()

# Individual step calls
source(dir_src("theme.R"))
source(dir_src("palette.R"))

################################################################################
# Run either the individual step calls or
# the notebook which does the same whileto build the report
################################################################################

# Prep TJI before downloading everything
source(dir_src("tji.R"))
cat(tji_hed_body)

source(dir_src("get.R"))
run_process()
run_analyze()

# Get the initial graphic and tweet ready
source(dir_src("visualize_strings.R"))
source(dir_src("visualize_daily_case_status.R"))
source(dir_src("tweets.R"))

run_visualize()

# source(dir_src("insights.R"))

upload_plots_s3()


