#!/bin/bash

set -euo pipefail

echo "========================================="
echo "Validating Notification AMI"
echo "========================================="

#############################################
# Elasticsearch Health Check
#############################################

echo "Checking Elasticsearch..."

until curl -s http://127.0.0.1:9200 >/dev/null
do
    sleep 2
done

ES_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:9200)

if [[ "$ES_STATUS" != "200" ]]; then
    echo "ERROR: Elasticsearch Health Check Failed"
    exit 1
fi

echo "Elasticsearch is Healthy."

#############################################
# Notification API Service
#############################################

echo "Checking Notification API Service..."

sudo systemctl is-active --quiet notification-api

echo "Notification API Service is Running."

#############################################
# Notification API Health Endpoint
#############################################

echo "Checking Notification API Health Endpoint..."

API_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
http://127.0.0.1:8085/api/v1/notification/health)

if [[ "$API_STATUS" != "200" ]]; then
    echo "ERROR: Notification API Health Check Failed"
    exit 1
fi

echo "Notification API Health Check Passed."

#############################################
# Validate Python Virtual Environment
#############################################

echo "Checking Python Virtual Environment..."

if [[ ! -d /home/ubuntu/Notification/venv ]]; then
    echo "ERROR: Python Virtual Environment Not Found"
    exit 1
fi

echo "Python Virtual Environment Exists."

#############################################
# Validate Repository
#############################################

echo "Checking Notification Repository..."

if [[ ! -f /home/ubuntu/Notification/notification_api.py ]]; then
    echo "ERROR: Notification Repository Missing"
    exit 1
fi

echo "Notification Repository Verified."

#############################################
# Validate Notification Service
#############################################

echo "Checking Notification Service..."

sudo systemctl status notification-api --no-pager

#############################################
# Validation Completed
#############################################

echo "========================================="
echo "Notification AMI Validation Successful"
echo "========================================="
