#!/bin/bash

set -Eeuo pipefail

###############################################
# Files
###############################################

PACKER_VAR_FILE="packer.auto.pkrvars.hcl"
TF_VAR_FILE="terraform.tfvars"

###############################################
# Required Files
###############################################

FILES=(
"$PACKER_VAR_FILE"
"$TF_VAR_FILE"
"notification.pkr.hcl"
"install.sh"
"configure.sh"
"validate.sh"
"notification-api.service"
"elasticsearch.yml"
)

for file in "${FILES[@]}"; do
    [[ -f "$file" ]] || {
        echo "ERROR: $file not found."
        exit 1
    }
done

###############################################
# Required Commands
###############################################

for cmd in aws packer git python3; do
    command -v "$cmd" >/dev/null || {
        echo "ERROR: $cmd is not installed."
        exit 1
    }
done

###############################################
# AWS Authentication Check
###############################################

echo "Checking AWS credentials..."
aws sts get-caller-identity >/dev/null

###############################################
# Read Variables
###############################################

source <(
python3 <<EOF
import re

for f in ("terraform.tfvars","packer.auto.pkrvars.hcl"):
    with open(f) as fp:
        for line in fp:
            m = re.match(r'(\w+)\s*=\s*"([^"]+)"', line)
            if m:
                print(f'{m.group(1).upper()}="{m.group(2)}"')
EOF
)

###############################################
# Validate Required Variables
###############################################

: "${AWS_REGION:?AWS_REGION missing}"
: "${VPC_NAME:?VPC_NAME missing}"
: "${AMI_NAME:?AMI_NAME missing}"

###############################################
# Discover Infrastructure
###############################################

echo "Finding VPC..."

VPC_ID=$(aws ec2 describe-vpcs \
    --region "$AWS_REGION" \
    --filters "Name=tag:Name,Values=$VPC_NAME" \
    --query "Vpcs[0].VpcId" \
    --output text)

[[ "$VPC_ID" == "None" || -z "$VPC_ID" ]] && {
    echo "ERROR: VPC not found."
    exit 1
}

echo "Finding Public Subnet..."

SUBNET_ID=$(aws ec2 describe-subnets \
    --region "$AWS_REGION" \
    --filters \
        Name=vpc-id,Values="$VPC_ID" \
        Name=tag:Tier,Values=public \
    --query "Subnets[0].SubnetId" \
    --output text)

[[ "$SUBNET_ID" == "None" || -z "$SUBNET_ID" ]] && {
    echo "ERROR: Public subnet not found."
    exit 1
}

echo "Finding Packer Builder Security Group..."

SECURITY_GROUP_ID=$(aws ec2 describe-security-groups \
    --region "$AWS_REGION" \
    --filters \
        Name=tag:Purpose,Values=packer-builder \
        Name=vpc-id,Values="$VPC_ID" \
    --query "SecurityGroups[0].GroupId" \
    --output text)

[[ "$SECURITY_GROUP_ID" == "None" || -z "$SECURITY_GROUP_ID" ]] && {
    echo "ERROR: Packer Builder Security Group not found."
    exit 1
}

###############################################
# Display Build Information
###############################################

echo
echo "========== Build Information =========="

printf "%-25s %s\n" "AWS Region" "$AWS_REGION"
printf "%-25s %s\n" "Environment" "$ENVIRONMENT"
printf "%-25s %s\n" "Application" "$APPLICATION"
printf "%-25s %s\n" "VPC ID" "$VPC_ID"
printf "%-25s %s\n" "Public Subnet" "$SUBNET_ID"
printf "%-25s %s\n" "Security Group" "$SECURITY_GROUP_ID"
printf "%-25s %s\n" "AMI Name" "$AMI_NAME"

echo "======================================="
echo

###############################################
# Packer
###############################################

packer init .

packer fmt .

packer validate \
    -var-file="$PACKER_VAR_FILE" \
    -var "subnet_id=$SUBNET_ID" \
    -var "security_group_id=$SECURITY_GROUP_ID" \
    .

packer build \
    -var-file="$PACKER_VAR_FILE" \
    -var "subnet_id=$SUBNET_ID" \
    -var "security_group_id=$SECURITY_GROUP_ID" \
    .
