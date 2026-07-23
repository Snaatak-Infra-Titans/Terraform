#!/bin/bash

set -e

TFVARS="terraform.tfvars"

# -----------------------------
# Read values from terraform.tfvars
# -----------------------------

AWS_REGION=$(grep '^aws_region' "$TFVARS" | cut -d '"' -f2)
ENVIRONMENT=$(grep '^environment' "$TFVARS" | cut -d '"' -f2)

# Change this if your AMI variable has a different name
AMI_NAME=$(grep '^notification_ami_name' "$TFVARS" | cut -d '"' -f2)

INSTANCE_TYPE="t3.small"

# -----------------------------------------------------------------
# IMPORTANT
# -----------------------------------------------------------------
# Replace these with actual values or fetch dynamically later
# -----------------------------------------------------------------

SUBNET_ID="subnet-xxxxxxxxxxxxxxxx"

SECURITY_GROUP_ID="sg-xxxxxxxxxxxxxxxx"

# -----------------------------
# Export Packer Variables
# -----------------------------

export PKR_VAR_aws_region="$AWS_REGION"
export PKR_VAR_environment="$ENVIRONMENT"
export PKR_VAR_instance_type="$INSTANCE_TYPE"
export PKR_VAR_ami_name="$AMI_NAME"

export PKR_VAR_subnet_id="$SUBNET_ID"
export PKR_VAR_security_group_id="$SECURITY_GROUP_ID"

echo "Initializing Packer..."
packer init .

echo "Validating Template..."
packer validate notification.pkr.hcl

echo "Building AMI..."
packer build notification.pkr.hcl
