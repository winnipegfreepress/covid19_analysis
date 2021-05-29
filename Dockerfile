FROM rocker/tidyverse

# create an R user
ENV USER rstudio

# Copy project files into the docker container
COPY . /home/$USER/analysis

# Install packages from config.R through init.R
# This should but doesn't work
# RUN if [ -f init.R ]; then R --quiet -f init.R; fi

# Using duplicate requirements instead
COPY ./DockerConfig/requirements.R /tmp/requirements.R
RUN Rscript /tmp/requirements.R
