################################################################################
# Topline blocks -- run after everything else or in a separate session
################################################################################

if (!require("upstartr")) install.packages("upstartr")
library("upstartr")
run_config()

# Individual step calls
source(dir_src("theme.R"))
source(dir_src("palette.R"))

run_analyze()

source(dir_src("visualize_topline_blocks_strings.R"))
source(dir_src("visualize_topline_blocks_spark.R"))
