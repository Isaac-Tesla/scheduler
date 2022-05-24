#!/usr/bin/env bash
<< COMMENT

    Summary: This script deploys Apache Airflow into an Amazon Web
        Services Kubernetes =cluster using the official Helm chart and
        includes the podOperator. This assumes you are already logged 
        in to a specific cluster. The Helm chart can be found at:

        https://airflow.apache.org/docs/helm-chart/stable/index.html
    
    Note: To output a new values file, run this in a terminal window.
        helm show values apache-airflow/airflow > values.yaml

    Stages:
        0. SETUP
        1. NAMESPACE
        2. CREDENTIALS
        3. SERVICE PRINCIPAL
        4. STORAGE
        5. SECRETS
        6. CONFIGMAPS
        7. DEPLOY CHART

COMMENT


### 0. SETUP: ENVIRONMENT VARIABLES; EXPORTS CONSUMED IN CHART

NAMESPACE=airflow
HELM_CHART_VERSION=1.4.0  ### Chart 1.4.0 = Apache Airflow 2.2.3
CONTAINER_REGISTRY_NAME=ekscr
SECRET_CONTAINER_REGISTRY=registry-secret

PVC_DAGS=airflow-dags-pvc
PVC_LOGS=airflow-logs-pvc

### 0.1 SETUP: REQUIRED FUNCTIONS
source ./functions/create_namespace.sh

### 0.2 SETUP: CHECK HELM CHART AVAILABILITY
helm repo add apache-airflow https://airflow.apache.org
helm repo update
# helm search repo airflow


### 1. NAMESPACE: CONFIRM NAMESPACE
create_namespace \
    $NAMESPACE


### 2. CREDENTIALS: COLLECT THE AIRFLOW CREDENTIALS
SECRET_MANAGER_NAME=aws-sm

export SECRET_KEYS=( \
    "AIRFLOW-ADMIN-PASSWORD" \
    "AIRFLOW-ADMIN-USER" \
    "AIRFLOW-URL" \
    "AIRFLOW-WEBSERVER-SECRET-KEY" \
    "AIRFLOW-EMAIL" \
    "AIRFLOW-POSTGRESQL-PASSWORD" \
    "AIRFLOW-POSTGRESQL-USER"
)

get_secret_manager_secrets \
    $SECRET_MANAGER_NAME \
    "${SECRET_KEYS[@]}"


# WIP