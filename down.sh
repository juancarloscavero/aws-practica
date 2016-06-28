#!/bin/bash

if [ $# -eq 0 ]
then
  echo "No arguments supplied. Exiting.... "
  exit 1
fi

aws ec2 stop-instances --instance-ids $1 --region eu-west-1
