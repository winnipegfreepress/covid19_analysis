FROM rocker/tidyverse

# install the linux libraries needed for plumber
RUN apt-get update -qq && apt-get install -y \
  libssl-dev \
  libcurl4-gnutls-dev \
  libcairo2-dev \
  libxt-dev \
  libjpeg-dev \
  libgif-dev \
  libpng-dev

# create an R user
ENV USER wfpnews

# install devtools and upstartr
RUN R -e "install.packages('devtools')"
RUN R -e "install.packages('upstartr')"
RUN R -e "install.packages('showtextdb')"

COPY ./requirements.R /tmp/requirements.R
RUN Rscript /tmp/requirements.R

# Copy project files into the docker container
COPY . /home/$USER

