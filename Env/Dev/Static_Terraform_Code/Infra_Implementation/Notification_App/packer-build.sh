#!/bin/bash

set -Eeuo pipefail

PACKER_VAR_FILE="packer.auto.pkrvars.hcl"
TF_VAR_FILE="terraform.tfvars"

FILES=(
"$PACKER_VAR_FILE"
"$TF_VAR_FILE"
"notification.pkr.hcl"
"install.sh"
"configure.sh"
"validate.sh"
"notification-api.service"
"notification-sync.service"
"elasticsearch.yml"
)

for file in "${FILES[@]}"; do
    [[ -f "$file" ]] || {
        echo "ERROR: $file not found."
        exit 1
    }
done

for cmd in aws packer git python3; do
    command -v "$cmd" >/dev/null || {
        echo "ERROR: $cmd is not installed."
        exit 1
    }
done

echo "Checking AWS Credentials..."
aws sts get-caller-identity >/dev/null

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

: "${AWS_REGION:?AWS_REGION missing}"
: "${ENVIRONMENT:?ENVIRONMENT missing}"
: "${APPLICATION:?APPLICATION missing}"
: "${INSTANCE_TYPE:?INSTANCE_TYPE missing}"
: "${AMI_NAME:?AMI_NAME missing}"
: "${SUBNET_ID:?SUBNET_ID missing}"
: "${SECURITY_GROUP_ID:?SECURITY_GROUP_ID missing}"

echo
echo "========== Build Information =========="

printf "%-25s %s\n" "AWS Region" "$AWS_REGION"
printf "%-25s %s\n" "Environment" "$ENVIRONMENT"
printf "%-25s %s\n" "Application" "$APPLICATION"
printf "%-25s %s\n" "Instance Type" "$INSTANCE_TYPE"
printf "%-25s %s\n" "Subnet ID" "$SUBNET_ID"
printf "%-25s %s\n" "Security Group" "$SECURITY_GROUP_ID"
printf "%-25s %s\n" "AMI Name" "$AMI_NAME"

echo "======================================="
echo

echo "Initializing Packer..."
packer init .

echo "Formatting Template..."
packer fmt .

echo "Validating Template..."
packer validate \
  -var-file="$PACKER_VAR_FILE" \
  .

echo "Building AMI..."
packer build \
  -var-file="$PACKER_VAR_FILE" \
  .
