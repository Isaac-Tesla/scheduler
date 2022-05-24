#!/usr/bin/env bash


### 0. SETUP: IMPORT FUNCTIONS
source ./functions/terraform_continue_destroy.sh

### 0.1 SETUP: ENVIRONMENT VARIABLES
while read line; do export $line; done < .env


### 1. TERRAFORM: INITIALISE
echo "Initialising Terraform..."
cd ./terraform/eks
terraform init \
	-backend-config="bucket=${BUCKET_NAME}"

terraform_continue_destroy
terraform destroy -auto-approve
