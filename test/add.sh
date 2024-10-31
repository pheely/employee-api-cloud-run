#!/bin/bash

SVC_NAME="employee-api-ist"

EMPLOYEE_API=$(gcloud run services describe $SVC_NAME --format='value(status.address.url)')
TOKEN=$(gcloud auth print-identity-token)
curl -H "Authorization: Bearer $(gcloud auth print-identity-token)" \
  -d '{"first_name":"Shrek","last_name":"Unknown","department":"Royal","salary":200000,"age":25}' \
  -X POST $EMPLOYEE_API/api/employee | jq