#!/usr/bin/bash

source set_env.sh
ROOT_DIRECTORY=..
SCRIPT_DIRECTORY=`pwd`

gcloud config set project $PROJECT_ID
gcloud config set account $EDITOR_NAME
gcloud config set compute/region $REGION
gcloud config set compute/zone $REGION-a
gcloud config set run/region $REGION

# Enable APIs & Services
gcloud services enable cloudbuild.googleapis.com
gcloud services enable artifactregistry.googleapis.com

# Create an artifact registry repository 
gcloud artifacts repositories create $REPO --location REGION --repository-format docker

# Set up credentials to access the repo
gcloud auth configure-docker $REGION-docker.pkg.dev

# submit a build
cd $ROOT_DIRECTORY
gcloud builds submit --tag $REPOSITORY/$SERVICE_NAME --region $REGION
cd $SCRIPT_DIRECTORY
