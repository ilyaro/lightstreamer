#!/bin/bash
# Desc: crontab script to get all logs from lightstreamer container
# Need to be run in crontab each 1 minute
# Author: Ilya Rokhkin

## Standard name of lightstreamer container
container_name=ls-server

if [ "$( docker container inspect -f '{{.State.Running}}' $container_name )" == "true" ]; 
then
  echo $container_name is running> /logs/ls-docker.log
else
  
fi
