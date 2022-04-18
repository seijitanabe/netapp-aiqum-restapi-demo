#!/bin/bash

# Define the environment
API_URL=https://aiqum.demo.netapp.com/api
AIQUM_USER=admin
AIQUM_PWD=Netapp1!

# Encode authentication information
AUTH_BAS64=`echo -n $AIQUM_USER:$AIQUM_PWD | openssl enc -e -base64`

#SVM_NAME=svm1_cluster1
echo -n Input a SVM Name:
read SVM_NAME

#PSL_NAME=ITAP_Value
echo -n Input a Performance Service Level:
read PSL_NAME

#VOL_NAME
echo -n Input a volume name:
read VOL_NAME

#VOL_GB=100
echo -n Input volume size [GiB] :
read VOL_GB
VOL_BYTE=`expr 1024 \* 1024 \* 1024 \* $VOL_GB`

# Get SVM_KEY
SVM_KEY=`curl -k -s -X GET "$API_URL/datacenter/svm/svms?name=$SVM_NAME" -H "accept: application/json" -H "authorization: Basic $AUTH_BAS64"  | jq -r '.records[].key'` &> /dev/null

# Get PSL_KEY
PSL_KEY=`curl -k -s -X GET "$API_URL/storage-provider/performance-service-levels?name=$PSL_NAME" -H "accept: application/json" -H "authorization: Basic $AUTH_BAS64" | jq -r '.records[].key'` &> /dev/null

# Create a file share
curl -k -s -X POST "$API_URL/storage-provider/file-shares" -H "accept: application/json" -H "authorization: Basic $AUTH_BAS64" -H "Content-Type: application/json" -d "{ \"mountpoint\": \"/$VOL_NAME\", \"name\": \"$VOL_NAME\", \"performance_service_level\": { \"key\": \"$PSL_KEY\" }, \"space\": { \"size\": $VOL_BYTE }, \"svm\": { \"key\": \"$SVM_KEY\" }, \"type\": \"rw\"}" &> /dev/null
