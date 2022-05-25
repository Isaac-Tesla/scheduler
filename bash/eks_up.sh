#!/usr/bin/env bash

<< COMMENT

  Summary: Deploys an EKS cluster in AWS. Setup AWS Cli 
    login prior to running this. Note: Your user must have
    permissions to be able to see the nodes appear in the
    EKS dashboard.

  References:
    https://learn.hashicorp.com/tutorials/terraform/eks
    https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
    https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
    https://docs.aws.amazon.com/eks/latest/userguide/create-kubeconfig.html

  Stages:
      0. SETUP
      1. TERRAFORM

COMMENT


### 0. SETUP: IMPORT FUNCTIONS
source ./functions/terraform_continue.sh

### 0.1 SETUP: ENVIRONMENT VARIABLES
while read line; do export $line; done < .env


### 1. TERRAFORM: INITIALISE
cd ./terraform/eks
terraform init \
	-backend-config="bucket=${BUCKET_NAME}"

terraform plan -out .terraform_plan
terraform_continue
terraform apply .terraform_plan
