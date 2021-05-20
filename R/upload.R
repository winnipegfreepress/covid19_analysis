
plot_list <- list.files(dir_plots())

for (plot in plot_list){
  put_object( file=dir_plots(paste(plot, sep="")),
              object=
              paste('covid-19-tracker/images/', plot, sep=""),
              multipart=TRUE,
              acl='public-read',
              bucket='wfpdata'
             )
  Sys.sleep(.5)

}

# put_object( file=dir_plots('wfp-covid-19-deaths-per-capita-web.png'),
#             object= 'covid-19-tracker/images/wfp-covid-19-deaths-per-capita-web.png',
#             multipart=TRUE,
#             acl='public-read',
#             bucket='wfpdata'
#            )

