## GCP project
PROJECT_ID=ibcwe-event-layer-f3ccf6d9
REGION=us-central1

## Database
INSTANCE_NAME=sql-db
DB_NAME=hr
DB_USER=user

## Secret manager secret
SECRET_NAME=employee-db-user-pw

gcloud config set project $PROJECT_ID
gcloud config set compute/region $REGION
gcloud config set compute/zone $REGION-a
gcloud config set run/region $REGION

# Enable APIs & Services
gcloud services enable secretmanager.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable sql-component.googleapis.com