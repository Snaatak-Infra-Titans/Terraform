#!/bin/bash

set -e

PACKER_VAR_FILE="packer.auto.pkrvars.hcl"

echo "Checking AWS credentials..."
aws sts get-caller-identity >/dev/null

echo "Initializing Packer..."
packer init .

echo "Formatting template..."
packer fmt .

echo "Validating template..."
packer validate \
  -var-file="$PACKER_VAR_FILE" \
  .

echo "Building AMI..."
packer build \
  -var-file="$PACKER_VAR_FILE" \
  .
