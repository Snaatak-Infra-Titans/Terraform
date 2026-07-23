#!/bin/bash

set -euo pipefail

echo "========================================="
echo "Configuring Notification AMI"
echo "========================================="

###########################################
# Reload Systemd
###########################################

sudo systemctl daemon-reload

###########################################
# Install Notification Service
###########################################

echo "Installing notification-api.service..."

sudo mv /tmp/notification-api.service \
/etc/systemd/system/notification-api.service

sudo chmod 644 \
/etc/systemd/system/notification-api.service

###########################################
# Enable Elasticsearch
###########################################

echo "Enabling Elasticsearch..."

sudo systemctl enable elasticsearch

###########################################
# Enable Notification API
###########################################

echo "Enabling Notification API..."

sudo systemctl enable notification-api

###########################################
# Start Elasticsearch
###########################################

echo "Starting Elasticsearch..."

sudo systemctl start elasticsearch

echo "Waiting for Elasticsearch..."

sleep 20

###########################################
# Start Notification API
###########################################

echo "Starting Notification API..."

sudo systemctl start notification-api

echo "========================================="
echo "Configuration Completed"
echo "========================================="
