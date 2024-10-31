#!/bin/bash

SVC_NAME="employee-api-ist"

EMPLOYEE_API=$(gcloud run services describe $SVC_NAME --format='value(status.address.url)')
TOKEN=$(gcloud auth print-identity-token)
curl -H "Authorization: Bearer $TOKEN"   $EMPLOYEE_API/api/employee | jq 