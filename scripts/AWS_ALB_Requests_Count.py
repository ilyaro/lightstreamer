import argparse
import datetime
import os

## Parse arguments start date nad end dtae in ISO format
parser = argparse.ArgumentParser()
parser.add_argument('--start-time', dest='start_time', type=datetime.datetime.fromisoformat, required=True, help="Start time of ALB metrics in format YYYY-MM-DDTHH:MM:SS Example: 2020-08-25T13:20:00")
parser.add_argument('--end-time', dest='end_time', type=datetime.datetime.fromisoformat, required=True, help="End time of ALB metrics in format YYYY-MM-DDTHH:MM:SS 2020-08-25T14:00:00")

args = parser.parse_args()

## cast datetime to string
start_time_str = args.start_time.strftime("%Y-%m-%dT%H:%M:%S"'Z')
end_time_str = args.end_time.strftime("%Y-%m-%dT%H:%M:%S"'Z')

##print("StarTime: " + start_time_str)
##print("EndTime: " + end_time_str)

## run aws configure before
os.system("aws configure")
## command arguments
ALB_requestcount='aws cloudwatch get-metric-statistics --namespace AWS/ApplicationELB --metric-name RequestCount --statistics Sum  --dimensions Name=LoadBalancer,Value=app/OM2-Exam-ALB/7192452843c40492 Name=TargetGroup,Value=targetgroup/OM2-Exam-ALB-TG/43d9332b0d54624e --period 3600 --start-time ' + start_time_str + ' --end-time ' + end_time_str
print("Command being running: ")
print(ALB_requestcount)

## Run the command to get ALB requests count
os.system(ALB_requestcount)
