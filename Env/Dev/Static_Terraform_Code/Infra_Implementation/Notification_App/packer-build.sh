#!/bin/bash

set -euo pipefail

#############################################
# Read Packer Variables
#############################################

PACKER_VARS_FILE="packer.auto.pkrvars.hcl"

AWS_REGION=$(awk -F'"' '/aws_region/ {print $2}' ${PACKER_VARS_FILE})
ENVIRONMENT=$(awk -F'"' '/environment/ {print $2}' ${PACKER_VARS_FILE})
APPLICATION=$(awk -F'"' '/application/ {print $2}' ${PACKER_VARS_FILE})
INSTANCE_TYPE=$(awk -F'"' '/instance_type/ {print $2}' ${PACKER_VARS_FILE})
AMI_NAME=$(awk -F'"' '/ami_name/ {print $2}' ${PACKER_VARS_FILE})
SSM_INSTANCE_PROFILE=$(awk -F'"' '/ssm_instance_profile/ {print $2}' ${PACKER_VARS_FILE})

#############################################
# Read Terraform Variables
#############################################

TFVARS_FILE="terraform.tfvars"

VPC_NAME=$(awk -F'"' '/vpc_name/ {print $2}' ${TFVARS_FILE})

#############################################
# Fetch VPC
#############################################

echo "Fetching VPC..."

VPC_ID=$(aws ec2 describe-vpcs \
    --region ${AWS_REGION} \
    --filters "Name=tag:Name,Values=${VPC_NAME}" \
    --query "Vpcs[0].VpcId" \
    --output text)

#############################################
# Fetch Backend Subnet
#############################################

echo "Fetching Backend Subnet..."

SUBNET_ID=$(aws ec2 describe-subnets \
    --region ${AWS_REGION} \
    --filters \
        "Name=vpc-id,Values=${VPC_ID}" \
        "Name=tag:Tier,Values=backend" \
    --query "Subnets[0].SubnetId" \
    --output text)

#############################################
# Fetch Notification Security Group
#############################################

echo "Fetching Notification Security Group..."

SECURITY_GROUP_ID=$(aws ec2 describe-security-groups \
    --region ${AWS_REGION} \
    --filters \
        "Name=tag:Name,Values=*notification*" \
    --query "SecurityGroups[0].GroupId" \
    --output text)

#############################################
# Validation
#############################################

[[ "$VPC_ID" == "None" || -z "$VPC_ID" ]] && {
    echo "ERROR: VPC not found"
    exit 1
}

[[ "$SUBNET_ID" == "None" || -z "$SUBNET_ID" ]] && {
    echo "ERROR: Backend subnet not found"
    exit 1
}

[[ "$SECURITY_GROUP_ID" == "None" || -z "$SECURITY_GROUP_ID" ]] && {
    echo "ERROR: Notification Security Group not found"
    exit 1
}

#############################################
# Export Variables
#############################################

export PKR_VAR_aws_region="${AWS_REGION}"
export PKR_VAR_environment="${ENVIRONMENT}"
export PKR_VAR_application="${APPLICATION}"
export PKR_VAR_instance_type="${INSTANCE_TYPE}"
export PKR_VAR_ami_name="${AMI_NAME}"
export PKR_VAR_subnet_id="${SUBNET_ID}"
export PKR_VAR_security_group_id="${SECURITY_GROUP_ID}"
export PKR_VAR_ssm_instance_profile="${SSM_INSTANCE_PROFILE}"

#############################################
# Build
#############################################

echo "Initializing Packer..."
packer init .

echo "Formatting..."
packer fmt .

echo "Validating..."
packer validate \
    -var-file=packer.auto.pkrvars.hcl \
    notification.pkr.hcl

echo "Building Notification AMI..."

packer build \
    -var-file=packer.auto.pkrvars.hcl \
    notification.pkr.hcl
