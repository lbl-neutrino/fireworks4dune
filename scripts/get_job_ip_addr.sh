#!/bin/bash

JOB_ID=${1}

echo "Getting IP address for job ${JOB_ID}"
NODE_ID=$(scontrol show job $JOB_ID  | grep -oP '^[[:blank:]]*NodeList=\K\S+')
IP_ADDR=$(ssh -q $NODE_ID "ip -4 -o addr show hsn0" | awk -F ' *|/' '{print $4}')

echo "Job on ${NODE_ID}"
echo -e "IPs from 'hsn0':\n$IP_ADDR"
