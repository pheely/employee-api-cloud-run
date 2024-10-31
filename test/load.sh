#!/bin/bash

SVC_NAME="employee-api-ist"
EMPLOYEE_API=$(gcloud run services describe $SVC_NAME --region=us-central1 --format='value(status.address.url)')
TOKEN=$(gcloud auth print-identity-token)

call() {
  for i in {1..10000}
  do 
    curl -Z -H "Authorization: Bearer $TOKEN"   $EMPLOYEE_API/api/employee > /dev/null 2>&1 &
    curl -Z -H "Authorization: Bearer $TOKEN"   $EMPLOYEE_API/api/help > /dev/null 2>&1 &
  done
}

call &