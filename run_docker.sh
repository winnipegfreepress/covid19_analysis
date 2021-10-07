#!/bin/bash
# Simple docker run command.
# -d flag runs in detatched mode
# use -it to start in interactive mode
# --rm removes the container on exit

DATA_DIR=${PWD}
sudo docker run -d --rm -p 28787:8787 --name covid19_analysis -e USERID=$UID -e PASSWORD="a Better Password than this 1 plz." -v $DATA_DIR:/home/$USER/ covid19_analysis
