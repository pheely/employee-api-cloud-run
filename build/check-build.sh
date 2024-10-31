#!/usr/bin/bash

source set_env.sh

gcloud builds list --region $REGION \
  --filter="create_time>$BUILD_DATE" \
  --format='table[box,margin=3](ID,CREATE_TIME,DURATION,STATUS)' \
  --sort-by=~create_time