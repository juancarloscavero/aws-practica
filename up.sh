#!/bin/bash

var=$(aws ec2  describe-instances --region eu-west-1 --filters 'Name=image-id,Values=ami-ae47dcdd' | jq -r .Reservations[0].OwnerId)
if [[ $var == null ]]; then

        id=$(aws ec2 run-instances --image-id ami-ae47dcdd --region eu-west-1 --subnet-id subnet-9b3e9eed --instance-type t2.micro --key-name TESTDEVOPS | jq -r .Instances[].InstanceId)
        aws  ec2  create-tags --resources $id --tags Key=Name,Value=Bastion --region eu-west-1
        sleep 5
        status=$(aws ec2 describe-instance-status --instance-id $id --region eu-west-1 | jq -r .InstanceStatuses[0].InstanceState.Name)
        while [[ $status != "running" ]]; 
        do
                sleep 3
                echo ...
                status=$(aws ec2 describe-instance-status --instance-id $id --region eu-west-1 | jq -r .InstanceStatuses[0].InstanceState.Name)
                echo 'Encendida bitch!!!'
        done

fi