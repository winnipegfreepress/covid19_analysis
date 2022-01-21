# =======================================================================
# Project-specific functions.
# =======================================================================


`%notin%`=function(x,y) !(x %in% y)


# ggsave two for one
ggsave_pngpdf <-  function(plot_var, fileslug_var, formats="png", width_var=8.66, height_var=6, dpi_var=300, scale_var=1, units_var="in"){

  if(!is.na(formats)){
    ggsave(dir_plots(paste({{ fileslug_var }}, ".png", sep="")), plot={{ plot_var }}, device="png", type="cairo", scale={{ scale_var }}, width={{ width_var }}, height={{ height_var }}, units={{ units_var }}, dpi={{ dpi_var }}, bg="#ffffff",  limitsize=TRUE)
    ggsave(dir_plots(paste({{ fileslug_var }}, "_lores.png", sep="")), plot={{ plot_var }}, device="png", type="cairo", scale={{ scale_var }}, width={{ width_var }}, height={{ height_var }}, units={{ units_var }}, dpi=96, limitsize=TRUE)
    ggsave(dir_plots(paste({{ fileslug_var }}, ".pdf", sep="")), plot={{ plot_var }}, device=cairo_pdf, scale={{ scale_var }}, width={{ width_var }}, height={{ height_var }}, units={{ units_var }}, dpi={{ dpi_var }}, bg="#ffffff",  limitsize=TRUE)
  }
  else{
    if(formats == "png"){
      ggsave(dir_plots(paste({{ fileslug_var }}, ".png", sep="")), plot={{ plot_var }}, device="png", type="cairo", scale={{ scale_var }}, width={{ width_var }}, height={{ height_var }}, units={{ units_var }}, dpi={{ dpi_var }}, bg="#ffffff",  limitsize=TRUE)
      ggsave(dir_plots(paste({{ fileslug_var }}, "_lores.png", sep="")), plot={{ plot_var }}, device="png", type="cairo", scale={{ scale_var }}, width={{ width_var }}, height={{ height_var }}, units={{ units_var }}, dpi=96, limitsize=TRUE)
    }

    if(formats == "pdf"){
      ggsave(dir_plots(paste({{ fileslug_var }}, ".pdf", sep="")), plot={{ plot_var }}, device=cairo_pdf, scale={{ scale_var }}, width={{ width_var }}, height={{ height_var }}, units={{ units_var }}, dpi={{ dpi_var }}, bg="#ffffff",  limitsize=TRUE)
    }
  }

  # ggsave_instagram({{ plot_var }}, {{ fileslug_var }})

}



# ggsave two for one
ggsave_instagram <-  function(plot_var, fileslug_var, formats="png"){

  # Instagram Post	1080 x 1080 (1:1 ratio)
  # Instagram Profile Photo 	360 x 360
  # Instagram Landscape Photo 	1080 X 608 (1.91:1 ratio)
  # Instagram Portrait 	1080 x 1350 (4:5 ratio)
  # Instagram Story 	1080 x 1920 (9:16 ratio)

  width_var=3.375
  height_var=6
  dpi_var=320
  scale_var=2.5
  units_var="in"

  ggsave(dir_plots(paste("IG/", {{ fileslug_var }}, "-IG", ".png", sep="")), plot={{ plot_var }}, device="png", type="cairo", scale={{ scale_var }}, width={{ width_var }}, height={{ height_var }}, units={{ units_var }}, dpi={{ dpi_var }}, bg="#ffffff",  limitsize=TRUE)

}

# Simple utility to upload png and pdf files to an s3 bucket
upload_plots_s3 <-  function(){

  plot_list <- list.files(dir_plots())

  for (plot in plot_list){
    put_object( file=dir_plots(paste(plot, sep="")),
                object=paste('covid-19-tracker/images/', plot, sep=""),
                multipart=TRUE,
                acl='public-read',
                bucket='wfpdata',
                verbose=TRUE,
                check_region=FALSE
    )
    Sys.sleep(.5)

  }

}



upload_reports_s3 <-  function(report="", destination_path=""){

  put_object( file=dir_reports(report),
              object=paste(destination_path, report, sep=""),
              multipart=TRUE,
              acl='public-read',
              bucket='wfpdata',
              verbose=TRUE,
              check_region=FALSE
  )
  Sys.sleep(.5)

}


############################################################
# Days since for growth
############################################################
count_days_since_1_10_100 <- function(df, column) {

  tmp_df <- df

  tmp_df$days_since_first <- NULL
  tmp_df$days_since_tenth <- NULL
  tmp_df$days_since_hundredth <- NULL

  counter_from_1 <- 0
  counter_from_10 <- 0
  counter_from_50 <- 0
  counter_from_100 <- 0

  for(i in 1:nrow(tmp_df)){

    if(!is.na(tmp_df[i,2])){
      if(tmp_df[i,2] >= 1){ counter_from_1 <- counter_from_1 +1 }
      if(tmp_df[i,2] >= 10){ counter_from_10 <- counter_from_10 +1 }
      if(tmp_df[i,2] >= 50){ counter_from_50 <- counter_from_50 +1 }
      if(tmp_df[i,2] >= 100){ counter_from_100 <- counter_from_100 +1 }
    }

    tmp_df[i,3]=counter_from_1
    tmp_df[i,4]=counter_from_10
    tmp_df[i,5]=counter_from_50
    tmp_df[i,6]=counter_from_100

  }

  invisible(tmp_df)

}


source(dir_src("function_plot_bar_dodge.R"))
source(dir_src("function_plot_bar_stack.R"))
source(dir_src("function_plot_bar_nominal.R"))
source(dir_src("function_plot_bar_stack_nominal.R"))
source(dir_src("function_plot_bar_x_reordered_y.R"))
source(dir_src("function_plot_bar_x_reordered_y_stacked.R"))
source(dir_src("function_plot_bar_x_reordered_y_stacked_pct.R"))
source(dir_src("function_plot_bar_timeseries_w_avg.R"))
source(dir_src("function_plot_bar_timeseries.R"))
source(dir_src("function_plot_line_timeseries_pct.R"))
source(dir_src("function_plot_line_timeseries.R"))


# source(dir_src("function_plot_bar_stack.R"))
# source(dir_src("function_plot_bar_timeseries.R"))
# source(dir_src("function_plot_bar_timeseries_w_avg.R"))
# source(dir_src("function_plot_bar_x_reordered_y.R"))
# source(dir_src("function_plot_line_timeseries.R"))
# source(dir_src("function_plot_line_timeseries_pct.R"))
