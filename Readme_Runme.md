# COVID-19 updates



In additional to pulling COVID-19 data feeds from provincial, federal and org sites we maintain a Winnipeg Free Press COVID-19 tracker on Google Sheets. 

https://docs.google.com/spreadsheets/d/19IqfhdXQaQbCJDns3yG0EEL4TAYGRgEGKKyLeELvLNA/edit#gid=362680117

Request edit access if you are not using the WFP group credentials. 



## Monday to Friday -- TJI

The weekday COVID-19 bulletin provides Winnipeg test positivity, regional case breakdowns and minimal details of the reported deaths. Some of this information is compiled and not available elsewhere. 

Update the fields in the **TJI** worksheet as follows:

**daily_deaths:** total number of CVOID-19 deaths the province is reporting 
**positivity_manitoba:** Provincial 5-day test positivity rate
**positivity_winnipeg:** Winnipeg's 5-day test positivity rate
**hospitalized_total:** Total COVID-19 hospitalization in Manitoba 
**icu_total:** Total COVID-19 ICU occupancy in Manitoba 
**rha_interlake:** Reported total for each health region
**rha_northern:** Reported total for each health region
**rha_prairiemountain:** Reported total for each health region
**rha_southern:** Reported total for each health region
**rha_winnipeg:** Reported total for each health region
**death_bullet:** One entry for each disclosed death, copy-paste the bullets from the bulletin and then duplicate the field name as required. Remove any unused *death_bullets*. 



Update the fields and process the data using `run_tji.R` (see below).



## Daily totals

The province compiles some COVID-19 data for the daily bulletin. Enter those values in the **Daily totals** worksheet and, on weekdays, the **test positivity** worksheet when Winnipeg's rate is reported. 

Enter values using a combination of the bulletin and the dashboard

https://experience.arcgis.com/experience/f55693e56018406ebbd08b3492e99771

* new_daily_cases	
* confirmed and probable	
* active	
* recovered	
* deaths	
* total_hospital	
* total_ICU	
* active_hospital	
* active_ICU	
* test to date



The blue columns calculate several daily differences and can be left mostly as-is except for the **new_daily_deaths** column which is affected when the province reports a deaths data correction. ON those days, manually enter the reported number of deaths in the field. 

One the fields are update, proceed to `run.R` below.

### Weekly Epi reports

The province publishes a weekly COVID-19 report on most Monday's. Key metrics are tracked in these worksheets. TKTK on what to update.

* health-care workers
* symptoms
* transmission source



## R for analysis, graphics, notebooks and TJIs

Tracked data along with provincial, federal and org data feeds is processed and analysed using an application written in R. The code run analysis, assembled a TJI, generates programned graphics and produces notebooks for reporters to reference. 

* Open a new browser tab for  [RStudio on Digital Ocean](http://159.203.52.224:28787/) using the provided credentials. You should see a three or four pane layout. 

	* Files are listed in the lower-left. Files are opened and ready to run in the upper-left. Key menu items are shown with an arrow.

* ![rstudio](/Users/michael/Desktop/rstudio.png)

	

* It is best to start with a new session to ensure a clean slate. From the RStudio menu, select **Session** and **Restart R**.  Also clear the console with **CTRL-L**.![restart-R](/Users/michael/Desktop/restart-R.png)

	

	### TJI

* The `run_tji.R` file should be visible in the upper-left Source pane. If not, double-click on the filename in the Files pane. 

* To run the TJI code, click the **Source** icon (blue arrow pointing right) in the upper-right of the Source pane. You can also select **Source** from the **Code**  menu. 

![menu-code-source](/Users/michael/Desktop/menu-code-source.png)

The TJI code will run and output a hed and body in the **Console** pane on the right. Select the compiled text and paste it into a new TJI entry in Click, setting expiry to 24 hours and target *This just in* under *Latest*. 

![console.tji-copy-paste](/Users/michael/Desktop/console.tji-copy-paste.png)



## Generating graphics, notebooks and more with R

When all of the required fields have been filled in the relevant Google Sheets, open the `run.R` file from the file browser pane and click **Source**. 

This file takes a few minutes to run. Messages will appear in the console on the right including warnings and errors. The console will also report when generated files are being uploaded to the Amazon bucket. 

![rstudio_run](/Users/michael/Desktop/rstudio_run.png)