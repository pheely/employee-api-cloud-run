#!/bin/sh

if [ $# -ne 2 ]; then
  echo "HELP: $0 [UC1 | UE4] <REL_NUM>"
  exit 1
fi

region_code=`echo $1 | tr a-z A-Z`

if [ $region_code = "UC1" ]; then
  REGION="us-central1"
elif [ $region_code = "UE4" ]; then
  REGION="us-east4"
else
  echo "Invalid region name"
  echo "HELP: $0 [UC1 | UE4] <REL_NUM>"
  exit 1
fi

REL_NAME=employee-api-release-$2
echo "Creating release $REL_NAME in $REGION"

gcloud deploy releases create $REL_NAME \
  --project=ibcwe-event-layer-f3ccf6d9 \
  --region=$REGION \
  --delivery-pipeline=employee-api-cd-pipeline \
  --images employee-api-image=us-central1-docker.pkg.dev/ibcwe-event-layer-f3ccf6d9/cloud-run-try/employee-service@sha256:1e51ac7859fe72db393e3a045cc8594358f16bb6cfa020cad6c18012e55d6e84