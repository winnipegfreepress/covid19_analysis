if (!require("upstartr")) install.packages("upstartr")
library("upstartr")
run_config()


################################################################################
# Run analysis steps
################################################################################
run_analyze()


################################################################################
# Run notebooks
################################################################################
run_notebook(filename="vaccinations.Rmd")
upload_reports_s3(report="vaccinations.html", destination_path="covid-19-tracker/")


################################################################################
# Run visuals and upload to S3 bucket
################################################################################
run_visualize()
upload_plots_s3()


################################################################################
# Run attic graphic -- this changes the graphics driver.
# Restart sessions if type looks too small
################################################################################
source(dir_src("visualize_topline_blocks_strings.R"))
source(dir_src("visualize_topline_blocks_spark.R"))

