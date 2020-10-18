FROM lightstreamer

# Please specify a COPY command only for the the required custom configuration file
## conf file with pport 80 for task II
##COPY conf/lightstreamer_conf.xml /lightstreamer/conf/lightstreamer_conf.xml
USER lightstreamer
VOLUME '[/ligitstreamer/logs:/ligitstreamer/logs]'
