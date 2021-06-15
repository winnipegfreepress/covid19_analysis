if (!require("upstartr")) install.packages("upstartr")
library("upstartr")
run_config()


# COVID-19 analysis notebook
# run_notebook(filename="index.Rmd")

run_notebook(filename="vaccinations.Rmd")
upload_reports_s3(report="vaccinations.html", destination_path="covid-19-tracker/")

# run_notebook(filename="covid19_2nd_3rd_wave.Rmd")
# upload_reports_s3(report="covid19_2nd_3rd_wave.html", destination_path="covid-19-tracker/")



