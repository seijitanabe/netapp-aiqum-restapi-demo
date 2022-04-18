#!/bin/bash

# Define the environment
API_URL=https://aiqum.demo.netapp.com/api
AIQUM_USER=admin
AIQUM_PWD=Netapp1!

# Encode authentication information
AUTH_BAS64=`echo -n $AIQUM_USER:$AIQUM_PWD | openssl enc -e -base64`

echo -n Input a source SVM name:
read SVM_NAME

echo -n Input a source volume name:
read SRC_VOL_NAME

echo -n Input a clone volume name:
read CLONE_VOL_NAME

# Get CLUSTER_UUID
CLUSTER_UUID=`curl -k -s -X GET "$API_URL/datacenter/svm/svms?name=$SVM_NAME" -H "accept: application/json" -H "authorization: Basic $AUTH_BAS64"  | jq -r '.records[].cluster.uuid'` &> /dev/null

# Create a FlexClone volume
curl -k -s -X POST "$API_URL/gateways/$CLUSTER_UUID/storage/volumes" -H "accept: application/json" -H "authorization: Basic $AUTH_BAS64" -H "Content-Type: application/json" -d "{ \"clone\": { \"is_flexclone\": true, \"parent_svm\": { \"name\": \"$SVM_NAME\" }, \"parent_volume\": { \"name\": \"$SRC_VOL_NAME\" }, \"split_initiated\": false }, \"nas\": { \"path\": \"/$CLONE_VOL_NAME\" }, \"svm\": { \"name\": \"$SVM_NAME\" }, \"name\": \"$CLONE_VOL_NAME\", \"type\": \"rw\"}"  &> /dev/null
