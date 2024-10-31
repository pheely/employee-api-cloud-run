#!/usr/bin/bash

## GCP project
EDITOR_NAME=philip.yang@scotiabank.com
PROJECT_ID=ibcwe-event-layer-f3ccf6d9
REGION=us-central1

## Artifact Registry
REPOSITORY=$REGION-docker.pkg.dev/$PROJECT_ID/cloud-run-try

## Database
INSTANCE_NAME=sql-db
DB_VERSION=MYSQL_8_0
DB_NAME=hr
DB_USER=user
PASSWORD=changeit

## Redis memorystore
REDIS_INSTANCE=employee
REDIS_TIER=basic
REDIS_SIZE=1

## VPC connector
VPC_CONNECTOR=employee
VPC_IP_RANGE="10.0.0.0/28"

## Secret manager secret
SECRET_NAME=DB_PASS

## Pubsub 
TOPIC_NAME=employee_creation
SUBSCRIPTION_NAME=employee-creation-sub


## Cloud run
SERVICE_NAME=employee-service
CLOUD_RUN_SA="gyre-dataflow@${PROJECT_ID}.iam.gserviceaccount.com"
INVOKER_SA=employee-api-invoker