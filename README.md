# covid19_analysis

Michael Pereira <monkeycycle@gmail.com>'



## Data sources

### WFP's COVID-19 bulletin tracker

* [TJI fields](https://docs.google.com/spreadsheets/d/19IqfhdXQaQbCJDns3yG0EEL4TAYGRgEGKKyLeELvLNA/edit#gid=362680117)

* [Daily totals](https://docs.google.com/spreadsheets/d/19IqfhdXQaQbCJDns3yG0EEL4TAYGRgEGKKyLeELvLNA/edit#gid=1935428018)

* [Local five-day test positivity](https://docs.google.com/spreadsheets/d/19IqfhdXQaQbCJDns3yG0EEL4TAYGRgEGKKyLeELvLNA/edit#gid=322055627)
	Winnipeg's test positivity rate is only available through the daily COVID-19 bulletin. The provincial rate is available through dashboard feeds. **Dated to the day prior to match feed dates**





----

```docker build --rm --force-rm -t docker-data-r .```

```docker run -d --rm -p 28787:8787 --name docker-data-r -e USERID=$UID -e PASSWORD=9[rRVK%b_^xS3_,<! -v $DATA_DIR:/home/rstudio/analysis docker-data-r```
