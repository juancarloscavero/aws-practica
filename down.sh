#!/bin/bash

if [ $# -eq 0 ]
then
  echo "No arguments supplied. Exiting.... "
  exit 1
fi

aws ec2 stop-instances --instance-ids $1 --region eu-west-1

status=$(aws ec2 describe-instance-status --instance-id $1 --region eu-west-1 | jq -r .InstanceStatuses[0].InstanceState.Name)
	while [[ $status != "null" ]]; 
	do
		sleep 3
		echo 'wait'
		status=$(aws ec2 describe-instance-status --instance-id $1 --region eu-west-1 | jq -r .InstanceStatuses[0].InstanceState.Name)
	done  

	echo 'Eliminada intancia!'