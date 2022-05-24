#!/usr/bin/env bash

<< COMMENT

  Summary: Deploys an EKS cluster in AWS. Setup AWS Cli 
    login prior to running this. Note: Your user must have
    permissions to be able to see the nodes appear in the
    EKS dashboard.

  Design based on:
    https://learn.hashicorp.com/tutorials/terraform/eks
    https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

  Stages:
      0. SETUP
      1. TERRAFORM
      2. KUBERNETES
      3. CLEANUP
      4. LOGIN

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


### 2. KUBERNETES: INITIALISE
### 2.1 KUBERNETES: COLLECT CREDENTIALS
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

### 2.2 KUBERNETES: DEPLOY THE METRICS SERVER
###     https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl get deployment metrics-server -n kube-system

### 2.3 KUBERNETES: SETUP THE DASHBOARD, DEPLOY RESOURCES
###     https://github.com/kubernetes/dashboard/
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml
cd ../..
kubectl apply -f ./terraform/eks/kubernetes-dashboard-admin.rbac.yaml


### 3. CLEANUP
cd ./terraform/eks
rm -rf .terraform*
