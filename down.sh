#!/bin/bash

id=$(aws ec2 describe-instances --region eu-west-1 --filters 'Name=tag:Name,Values=Bastion' | jq -r .Reservations[].Instances[].InstanceId)
aws ec2 terminate-instances --instance-ids $id --region eu-west-1 

status=$(aws ec2 describe-instance-status --instance-id $id --region eu-west-1 | jq -r .InstanceStatuses[0].InstanceState.Name)
	while [[ $status != "null" ]]; 
	do
		sleep 3
		echo 'wait'
		status=$(aws ec2 describe-instance-status --instance-id $id --region eu-west-1  | jq -r .InstanceStatuses[0].InstanceState.Name)
	done  

	echo 'Eliminada intancia!'

