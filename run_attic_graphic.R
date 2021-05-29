################################################################################
# Topline blocks
# Borked PDF driver
# run this after everything else
# or in a separate session
################################################################################
if (!require("upstartr")) install.packages("upstartr")
library("upstartr")
run_config()
source(dir_src("theme.R"))
source(dir_src("palette.R"))
run_analyze()
source(dir_src("visualize_topline_blocks_strings.R"))
source(dir_src("visualize_topline_blocks_spark.R"))
