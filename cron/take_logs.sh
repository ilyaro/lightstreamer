#!/bin/bash
# Desc: crontab script to get all logs from lightstreamer container
# Need to be run in crontab each 1 minute
# On docker host run crontab -e and add this line
#[ec2-user@ip-172-25-1-101 lightstreamer]$ crontab -l
#*       *       *       *       *      /home/ec2-user/lightstreamer/cron/take_logs.sh 2>&1 > /tmp/take_logs.log
# Author: Ilya Rokhkin

date=`/usr/bin/date`
##log everithing to log
date_time=`date +%Y.%m.%d.%H.%M.%S`

## trap every output to /tmp/take_logs.log
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/tmp/take_logs.${date_time}.log 2>&1

set -euxo pipefail
## -e exit on error, -u exist on unset variable, -x debug prints, -o pipefail trap faulre of pipelines

## Standard name of lightstreamer container
container_name="ls-server2"
dirname="/lightstreamer/logs"
if [ ! -d "$dirname" ]; then
  mkdir -p $dirname;
fi
export log_file="${dirname}/ls-docker.log"

echo "" >> $log_file
echo "Log of $container_name of $date" >> $log_file
printf '=%.0s' {1..100} >> $log_file
echo "" >> $log_file
if [ "$( /usr/bin/docker container inspect -f '{{.State.Running}}' $container_name )" == "true" ]; 
then
  echo "Status: " $container_name " is running" >> $log_file
  ## CPU and memory of container running ligingstreamer
  /usr/bin/docker stats ls-server -a --no-stream | /usr/bin/grep ls-server | /usr/bin/awk '{print "Container CPU",$3,"Container Memory", $7}' >> $log_file
  ## LOgs size of lightstreamer
  echo -n "Logs size: " >> $log_file; /usr/bin/docker exec ls-server du -sh /lightstreamer/logs >> $log_file
  ## Get process Memory and CPU ToDo: $9 $10 CPU and Memory are diferent from system to sysyesm 
  ## Need to do it by %CPU and %MEM fields
  /usr/bin/top -b -n 1 -d 0.2 | /usr/bin/grep  `docker top $container_name | /usr/bin/grep lightst | /usr/bin/awk '{print $1}'` | /usr/bin/grep lightst | /usr/bin/awk '{print "Process CPU: ",$9"%"," Proecss Memory: " $10"%"}' >> $log_file
else
  echo "Status: " $container_name "is not running" >> $log_file 
fi
