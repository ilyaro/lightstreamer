#!/bin/bash
# Desc: crontab script to get all logs from lightstreamer container
# Need to be run in crontab each 1 minute
# Author: Ilya Rokhkin

## Standard name of lightstreamer container
container_name="ls-server"
date=`date`
dirname="/lightstreamer/logs"
if [ ! -d "$dirname" ]; then
  mkdir -p $dirname;
fi
log_file="${dirname}/ls-docker.log"
echo "Log of $container_name of $date" >> $log_file
printf '=%.0s' {1..100} >> $log_file
echo "" >> $log_file
if [ "$( docker container inspect -f '{{.State.Running}}' $container_name )" == "true" ]; 
then
  echo "Status: " $container_name " is running" >> $log_file
  ## CPU and memory of container running ligingstreamer
  docker stats ls-server -a --no-stream | grep ls-server | awk '{print "Container CPU",$3,"Container Memory", $7}' >> $log_file
  ## LOgs size of lightstreamer
  echo -n "Logs size: " >> $log_file; docker exec ls-server du -sh /lightstreamer/logs >> $log_file
  ## Get process Memory and CPU
  top -b -n 1 -d 0.2 | grep  `docker top ls-server | grep lightstreamer | awk '{print $1}'` | grep lightstreamer | awk '{print "Process CPU: ",$8,"Proecss Memory: " $5}' >> $log_file
else
  echo "Status: " $container_name "is not running" >> $log_file 
fi
