
FROM rocker/tidyverse

# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get install -y \
  libssl-dev \
  libcurl4-gnutls-dev

# create an R user
ENV USER wfpnews

# install devtools and upstartr
RUN R -e "install.packages('devtools')"
RUN R -e "install.packages('globeandmail/upstartr')"

# Install packages from config.R through init.R
# This should but doesn't work
# RUN if [ -f init.R ]; then R --quiet -f init.R; fi

# Using duplicate requirements instead
COPY ./requirements.R /tmp/requirements.R
RUN Rscript /tmp/requirements.R

# Copy project files into the docker container
COPY . /home/$USER/analysis
