if (!require("upstartr")) install.packages("upstartr")
library("upstartr")
run_config()


source(dir_src("tji.R"))

cat(tji_hed_body)




# Mail the TJI to webnewsfreepress.mb.ca, etc.
smtp_server <- list(smtpServer = "smtp.winnipegfreepress.com")
from <- sprintf("<michael.pereira@freepress.mb.ca>", "C19 bot c/o Michael Pereira")
to <- sprintf("<webnewsfreepress.mb.ca>")
subject <- paste("TJI TEST -- ", headline, sep=" ")
body <- paste("\n\n", story, "\n\n", sep="")



test_email <-
  gm_mime() %>%
  gm_to("PUT_A_VALID_EMAIL_ADDRESS_THAT_YOU_CAN_CHECK_HERE") %>%
  gm_from("PUT_THE_GMAIL_ADDRESS_ASSOCIATED_WITH_YOUR_GOOGLE_ACCOUNT_HERE") %>%
  gm_subject("this is just a gmailr test") %>%
  gm_text_body("Can you hear me now?")

# Verify it looks correct
gm_create_draft(test_email)

# If all is good with your draft, then you can send it
gm_send_message(test_email)
