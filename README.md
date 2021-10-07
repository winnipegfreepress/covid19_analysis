# covid19_analysis

Michael Pereira <monkeycycle@gmail.com>


This project collects, compiles, analyzes and viusualizes COVID-19 data -- primarily for the provinc of Manitoba.

The project can be run locally in RStudio or a server-based instance of RStudio can be deployed using Docker. 


## Docker install

Change user name and  RStudio login credentials in the `Dockerfile` and `run_docker.sh` files before proceeding

# Build the image

```docker build --rm --force-rm -t covid19_analysis .```

# Run the image

`sh ./run_docker.sh`

This sets data directory and defines credentials for the RStudio user defined in the `Dockerfile`. Adjust the `docker run ` options to suit. 


Login credentials for the default user (`wfpnews`) is set as a docker run option in `./run_docker.sh`. Change them before deploying and starting the container.


# Uploading graphics to production
Third-party credentials (AWS S3/Google API keys) are not included in build or run commands. 

** Credentials must be added to a .env file, from within the RStudio UI terminal, after every reboot including rebuild-reboot.

**Manually add a .env after the image is running.**

AWS credentials are required for uploads to the S3 bucket used for production graphics.


```
GOOGLE_API_KEY=qwertyuhgfvcghjuikjhnklo-kmkl
AWS_ACCESS_KEY_ID=qwertyuhgfvcghjuik-jhnklokmkl
AWS_SECRET_ACCESS_KEY=qwertyuhgfvcghjuikjhnklokmkl-qwertyuhgfvcghjuikjhnklokmkl

```

***** 

