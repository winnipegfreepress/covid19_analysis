if (!require("upstartr")) install.packages("upstartr")
library("upstartr")
run_config()
source(dir_src("tji.R"))

cat(tji_hed_body)




# Mail the TJI to webnews, etc.
smtp_server <- list(smtpServer = "smtp.winnipegfreepress.com")
from <- sprintf("<michael.pereira@freepress.mb.ca>", "C19 bot c/o Michael Pereira")
to <- sprintf("<webnewsfreepress.mb.ca>")
subject <- paste("TJI TEST -- ", headline, sep=" ")
body <- paste("\n\n", story, "\n\n", sep="")

sendmail(from, to, subject, body, control = list(smtp_server = "smtp.winnipegfreepress.com"))
