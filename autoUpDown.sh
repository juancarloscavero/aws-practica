#!/bin/bash

now=$(date +%H:%M)
apagar=$(aws ec2 describe-instances --region eu-west-1 --filters 'Name=tag:hora_apagado,Values=*' | jq -r '.Reservations[].Instances[].Tags[] | select(.Key=="hora_apagado")'| jq -r .Value)
echo $now 
echo $apagar
if [ "$apagar" == "$now" ]; then
        id=$(aws ec2 describe-instances --region eu-west-1 --filters "Name=tag:hora_apagado,Values='$apagar'" | jq -r .Reservations[].Instances[].InstanceId)
        echo $id
        status=$(aws ec2 describe-instance-status --instance-id $id --region eu-west-1 | jq -r .InstanceStatuses[0].InstanceState.Name)
        echo $status
        if [ "$status" != "stopped" ]; then
                aws ec2 stop-instances --region eu-west-1 --instance-ids $id
                while [[ "$status" != "stopped" ]]; 
				do
					sleep 3
					echo '...'
					status=$(aws ec2 describe-instance-status --instance-id $id --region eu-west-1  | jq -r .InstanceStatuses[0].InstanceState.Name)
				done  

				echo 'Stopped baby!'
        fi
fi
encender=$(aws ec2 describe-instances --region eu-west-1 --filters 'Name=tag:hora_encendido,Values=*' | jq -r '.Reservations[].Instances[].Tags[] | select(.Key=="hora_encendido")'| jq -r .Value)
if [ "$encender" == "$now" ]; then
        id=$(aws ec2 describe-instances --region eu-west-1 --filters "Name=tag:hora_encendido,Values='$encender'" | jq -r .Reservations[].Instances[].InstanceId)
        echo $id
        status=$(aws ec2 describe-instance-status --instance-id $id --region eu-west-1 | jq -r .InstanceStatuses[0].InstanceState.Name)
        echo $status
        if [ "$status" != "running" ]; then
                aws ec2 start-instances --region eu-west-1 --instance-ids $id
                while [[ "$status" != "running" ]]; 
        		do
                	sleep 3
                	echo ...
                	status=$(aws ec2 describe-instance-status --instance-id $id --region eu-west-1 | jq -r .InstanceStatuses[0].InstanceState.Name)
        		done
        		echo 'Encendida bitch!!!'
        fi
fi
