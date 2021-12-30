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
# Run visuals
################################################################################
run_visualize()



################################################################################
# Run attic graphic -- this changes the graphics driver.
# Restart sessions if type looks too small
################################################################################
# source(dir_src("visualize_topline_blocks_strings.R"))
# source(dir_src("visualize_topline_blocks_spark.R"))


################################################################################
# Upload the PDFs and PNGs to Amazon
################################################################################
upload_plots_s3()


cat("All done. That's it! ")

