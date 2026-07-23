#!/bin/bash

set -euo pipefail

#############################################
# Configuration Files
#############################################

PACKER_VARS_FILE="packer.auto.pkrvars.hcl"
TFVARS_FILE="terraform.tfvars"

#############################################
# Check Dependencies
#############################################

command -v aws >/dev/null 2>&1 || {
    echo "ERROR: AWS CLI is not installed."
    exit 1
}

command -v packer >/dev/null 2>&1 || {
    echo "ERROR: Packer is not installed."
    exit 1
}

#############################################
# Read Packer Variables
#############################################

AWS_REGION=$(grep '^aws_region' "$PACKER_VARS_FILE" | cut -d '"' -f2)
ENVIRONMENT=$(grep '^environment' "$PACKER_VARS_FILE" | cut -d '"' -f2)
APPLICATION=$(grep '^application' "$PACKER_VARS_FILE" | cut -d '"' -f2)
OWNER=$(grep '^owner' "$PACKER_VARS_FILE" | cut -d '"' -f2)
COST_CENTER=$(grep '^cost_center' "$PACKER_VARS_FILE" | cut -d '"' -f2)
INSTANCE_TYPE=$(grep '^instance_type' "$PACKER_VARS_FILE" | cut -d '"' -f2)
AMI_NAME=$(grep '^ami_name' "$PACKER_VARS_FILE" | cut -d '"' -f2)
SSM_INSTANCE_PROFILE=$(grep '^ssm_instance_profile' "$PACKER_VARS_FILE" | cut -d '"' -f2)

#############################################
# Read Terraform Variables
#############################################

VPC_NAME=$(grep '^vpc_name' "$TFVARS_FILE" | cut -d '"' -f2)

#############################################
# Validate Variables
#############################################

for VAR in \
AWS_REGION \
ENVIRONMENT \
APPLICATION \
OWNER \
COST_CENTER \
INSTANCE_TYPE \
AMI_NAME \
SSM_INSTANCE_PROFILE \
VPC_NAME
do
    if [[ -z "${!VAR}" ]]; then
        echo "ERROR: $VAR is empty."
        exit 1
    fi
done

#############################################
# Security Group Name
#############################################

NOTIFICATION_SG_NAME="${ENVIRONMENT}-${APPLICATION}-notification-sg"

#############################################
# Discover VPC
#############################################

echo "Discovering VPC..."

VPC_ID=$(aws ec2 describe-vpcs \
    --region "$AWS_REGION" \
    --filters "Name=tag:Name,Values=${VPC_NAME}" \
    --query "Vpcs[0].VpcId" \
    --output text)

#############################################
# Discover Backend Subnet
#############################################

echo "Discovering Backend Subnet..."

SUBNET_ID=$(aws ec2 describe-subnets \
    --region "$AWS_REGION" \
    --filters \
        "Name=vpc-id,Values=${VPC_ID}" \
        "Name=tag:Tier,Values=backend" \
    --query "Subnets[0].SubnetId" \
    --output text)

#############################################
# Discover Notification Security Group
#############################################

echo "Discovering Notification Security Group..."

SECURITY_GROUP_ID=$(aws ec2 describe-security-groups \
    --region "$AWS_REGION" \
    --filters \
        "Name=tag:Name,Values=${NOTIFICATION_SG_NAME}" \
    --query "SecurityGroups[0].GroupId" \
    --output text)

#############################################
# Validate AWS Resources
#############################################

[[ "$VPC_ID" == "None" || -z "$VPC_ID" ]] && {
    echo "ERROR: Unable to find VPC."
    exit 1
}

[[ "$SUBNET_ID" == "None" || -z "$SUBNET_ID" ]] && {
    echo "ERROR: Unable to find backend subnet."
    exit 1
}

[[ "$SECURITY_GROUP_ID" == "None" || -z "$SECURITY_GROUP_ID" ]] && {
    echo "ERROR: Unable to find Notification Security Group."
    exit 1
}

#############################################
# Resource Summary
#############################################

echo ""
echo "=========================================="
echo "Packer Build Configuration"
echo "=========================================="

echo "Region              : $AWS_REGION"
echo "Environment         : $ENVIRONMENT"
echo "Application         : $APPLICATION"
echo "VPC                 : $VPC_ID"
echo "Subnet              : $SUBNET_ID"
echo "Security Group      : $SECURITY_GROUP_ID"
echo "Instance Type       : $INSTANCE_TYPE"
echo "AMI Name            : $AMI_NAME"

echo "=========================================="

#############################################
# Build
#############################################

packer init .

packer fmt .

packer validate \
    -var-file="$PACKER_VARS_FILE" \
    notification.pkr.hcl

packer build \
    -var-file="$PACKER_VARS_FILE" \
    -var "subnet_id=$SUBNET_ID" \
    -var "security_group_id=$SECURITY_GROUP_ID" \
    notification.pkr.hcl
