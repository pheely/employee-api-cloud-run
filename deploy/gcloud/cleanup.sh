#!/usr/bin/bash

source set_env.sh

gcloud config set project $PROJECT_ID
gcloud config set account $EDITOR_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $REGION-a
gcloud config set run/region $REGION

# Enable APIs & Services
gcloud services enable run.googleapis.com
gcloud services enable secretmanager.googleapis.com
gcloud services enable artifactregistry.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable sql-component.googleapis.com
gcloud services enable pubsub.googleapis.com
gcloud services enable redis.googleapis.com
gcloud services enable vpcaccess.googleapis.com


gcloud run services delete $SERVICE_NAME
gcloud sql instances delete $INSTANCE_NAME
gcloud iam service-accounts delete "${INVOKER_SA}@${PROJECT_ID}.iam.gserviceaccount.com"
gcloud pubsub subscriptions delete $SUBSCRIPTION_NAME
gcloud pubsub topics delete $TOPIC_NAME
gcloud redis instances delete $REDIS_INSTANCE --region $REGION
gcloud compute networks vpc-access connectors delete $VPC_CONNECTOR --region $REGION
gcloud secrets delete $SECRET_NAME
gcloud artifacts packages delete $SERVICE_NAME --repository=$REPOSITORY --location=$REGION

