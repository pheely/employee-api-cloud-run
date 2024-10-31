#!/bin/bash
git config --global credential.'https://source.developers.google.com'.helper gcloud.sh
gcloud source repos create employee-api
git init
git remote add google https://source.developers.google.com/p/ibcwe-event-layer-f3ccf6d9/r/employee-api
