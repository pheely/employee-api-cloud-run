#!/usr/bin/bash
source set_env.sh
gcloud artifacts packages delete $SERVICE_NAME --repository=$REPOSITORY --location=$REGION