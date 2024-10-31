#!/usr/bin/bash

source set_env.sh
gcloud artifacts docker images list $REPOSITORY --filter="update_time>$BUILD_DATE" --format json|jq