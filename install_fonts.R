#! Rscript
# Install Open Sans into R:

skip = FALSE
if(require("extrafont")) {
	if ("Open Sans" %in% fonts()) {
    message("Open Sans already installed.")
		skip=TRUE;
	}
}

# Otherwise, install it!
if (! skip ) {
	local({r <- getOption("repos");
		   r["CRAN"] <- "http://cran.at.r-project.org";  #AUSTRIA mirror
		   options(repos=r)})

	install.packages(c("extrafont"))
	library("extrafont")

	# importing takes awhile but only has to be done once.
	font_import("./fonts/", prompt=FALSE)
	loadfonts()
}