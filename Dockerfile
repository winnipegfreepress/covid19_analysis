FROM rocker/tidyverse:3.3.1

## Copy repo files into the docker container
USER root
COPY . ${HOME}

# Install packages from init.R
RUN if [ -f init.R ]; then R --quiet -f init.R; fi

