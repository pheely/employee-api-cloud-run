#!/usr/bin/bash

source set_env.sh

# get the latest enabled version of secret
SECRET_VERSION=$(gcloud secrets versions list $SECRET_NAME --filter="STATE=enabled" --format="value(NAME)" --sort-by ~CREATED --limit 1)


# Get dbpassword from secret manager
MYSQL_PASS=$(gcloud secrets versions access $SECRET_VERSION --secret=$SECRET_NAME)

# Create and poplate tables
cloud-sql-proxy --port 3306 ${PROJECT_ID}:${REGION}:${INSTANCE_NAME} &
sleep 15
mysql -u user -p$MYSQL_PASS --host 127.0.0.1

