if (!require("upstartr")) install.packages("upstartr")
library("upstartr")
run_config()


# Render the Rmd and upload notebook to S3 bucket
run_notebook(filename="vaccinations.Rmd")
upload_reports_s3(report="vaccinations.html", destination_path="covid-19-tracker/")

