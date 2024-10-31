#!/bin/sh
  

ENVIRONMENTS="ist uat prd"
SERVICE_PREFIX="employee-api"
MANIFEST_PREFIX="employee"
TEMPLATE="manifest-template.yaml"

REGION=us-central1
REDIS_INSTANCE=employee

REDIS_HOST=`gcloud redis instances describe $REDIS_INSTANCE --region $REGION --format='value(host)'`

for ENV in $ENVIRONMENTS
do
    SERVICE_NAME=$SERVICE_PREFIX-$ENV
    MANIFEST_NAME=$MANIFEST_PREFIX-$ENV.yaml
    sed -e "s/<REDIS_HOST>/$REDIS_HOST/g" -e "s/<SVC_NAME>/$SERVICE_NAME/g"  $TEMPLATE > $MANIFEST_NAME
done