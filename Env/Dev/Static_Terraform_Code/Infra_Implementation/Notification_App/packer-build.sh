#!/bin/bash

set -euo pipefail

###########################################
# Configuration
###########################################

AWS_REGION="us-east-1"
ENVIRONMENT="dev"
APPLICATION="otms"

VPC_NAME="dev-otms-vpc"

AMI_NAME="notification-es-golden-v1"

INSTANCE_TYPE="t3.small"

KEY_NAME="dev-otms-key"

###########################################
# Discover VPC
###########################################

echo "Fetching VPC..."

VPC_ID=$(aws ec2 describe-vpcs \
    --region "$AWS_REGION" \
    --filters "Name=tag:Name,Values=$VPC_NAME" \
    --query "Vpcs[0].VpcId" \
    --output text)

###########################################
# Discover Backend Subnet
###########################################

echo "Fetching Backend Subnet..."

SUBNET_ID=$(aws ec2 describe-subnets \
    --region "$AWS_REGION" \
    --filters \
        "Name=vpc-id,Values=$VPC_ID" \
        "Name=tag:Tier,Values=backend" \
    --query "Subnets[0].SubnetId" \
    --output text)

###########################################
# Discover Notification Security Group
###########################################

echo "Fetching Notification Security Group..."

SECURITY_GROUP_ID=$(aws ec2 describe-security-groups \
    --region "$AWS_REGION" \
    --filters \
        "Name=tag:Name,Values=*notification*" \
    --query "SecurityGroups[0].GroupId" \
    --output text)

###########################################
# Validation
###########################################

if [[ "$VPC_ID" == "None" || -z "$VPC_ID" ]]; then
    echo "VPC not found."
    exit 1
fi

if [[ "$SUBNET_ID" == "None" || -z "$SUBNET_ID" ]]; then
    echo "Backend subnet not found."
    exit 1
fi

if [[ "$SECURITY_GROUP_ID" == "None" || -z "$SECURITY_GROUP_ID" ]]; then
    echo "Notification Security Group not found."
    exit 1
fi

###########################################
# Export Variables
###########################################

export PKR_VAR_aws_region="$AWS_REGION"
export PKR_VAR_environment="$ENVIRONMENT"
export PKR_VAR_instance_type="$INSTANCE_TYPE"

export PKR_VAR_subnet_id="$SUBNET_ID"
export PKR_VAR_security_group_id="$SECURITY_GROUP_ID"

export PKR_VAR_ami_name="$AMI_NAME"

###########################################
# Build
###########################################

echo "Initializing Packer..."
packer init .

echo "Validating Template..."
packer validate notification.pkr.hcl

echo "Building Notification AMI..."
packer build notification.pkr.hcl
