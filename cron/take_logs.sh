#!/bin/bash
# Desc: crontab script to get all logs from lightstreamer container
# Need to be run in crontab each 1 minute
# Author: Ilya Rokhkin

## Standard name of lightstreamer container
container_name="ls-server"
date=`date`
log_file="/logs/ls-docker.log"
echo "Log of $container_name of $date" > $log_file
if [ "$( docker container inspect -f '{{.State.Running}}' $container_name )" == "true" ]; 
then
  echo $container_name "is running" >> $log_file
else
  echo $container_name "is not running" >> $log_file 
fi
