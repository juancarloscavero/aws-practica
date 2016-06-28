#!/bin/bash

now=$(date +%H:%M)
hour=$(aws ec2 describe-instances --region eu-west-1 --filters 'Name=tag:hora_apagado,Values=*' | jq -r '.Reservations[].Instances[].Tags[] | select(.Key=="hora_apagado")'| jq -r .Value)
echo $now 
echo $hour
if [ $hour == $now ]; then
	id=$(aws ec2 describe-instances --region eu-west-1 --filters 'Name=tag:hora_apagado,Values=$hour' | jq -r .Reservations[].Instances[].InstanceId)
	aws ec2 terminate-instances --region eu-west-1 --instance-ids $id
fi