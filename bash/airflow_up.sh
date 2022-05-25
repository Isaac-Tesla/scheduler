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
        2. SECRETS
        3. CONFIGMAPS
        4. DEPLOY CHART

COMMENT


### 0. SETUP: ENVIRONMENT VARIABLES; EXPORTS CONSUMED IN CHART
NAMESPACE=airflow
HELM_CHART_VERSION=1.4.0
CONTAINER_REGISTRY_NAME=ekscr
SECRET_CONTAINER_REGISTRY=registry-secret

### 0.1 SETUP: ENVIRONMENT VARIABLES
while read line; do export $line; done < .env

### 0.2 SETUP: REQUIRED FUNCTIONS
source ./functions/create_namespace.sh

### 0.3 SETUP: CHECK HELM CHART AVAILABILITY
helm repo add apache-airflow https://airflow.apache.org
helm repo update
# helm search repo airflow


### 1.0 NAMESPACE: CONFIRM NAMESPACE
create_namespace \
    $NAMESPACE


### 2.0 SECRETS: CREATE WEBSERVER SECRET KEY
###     Note: Secret key name must match values.yaml 
###           -> webserverSecretKeySecretName
export SECRET_KEY_NAME=airflow-webserver-secret-key

kubectl create secret generic ${SECRET_KEY_NAME} \
    --from-literal=webserver-secret-key=${airflow_webserver_secret_key} \
    -n $NAMESPACE


### 3.0 CONFIGMAPS: DEPLOY AIRFLOW-CONFIGMAP
AIRFLOW_ADMIN_USER=${airflow_admin_user} \
    AIRFLOW_BASE_URL=${airflow_url} \
    envsubst < "./application/k8s/airflow/configmap_airflow_configmap.yaml" | kubectl apply -n $NAMESPACE -f -


### 4.0 DEPLOY CHART: DEPLOY THE HELM CHART
SECRET_KEY_NAME=${SECRET_KEY_NAME} \
    airflow_admin_user=${airflow_admin_user} \
    airflow_url=${airflow_url} \
    NAMESPACE=${NAMESPACE} \
    envsubst < ./application/k8s/airflow/override.yaml | helm upgrade --install \
        --set webserver.defaultUser.username=${airflow_admin_user} \
        --set webserver.defaultUser.password=${airflow_admin_password} \
        --set webserver.defaultUser.email=${airflow_email} \
        --set webserverSecretKeySecretName=${SECRET_KEY_NAME} \
        --set executor="KubernetesExecutor" \
        --set dags.gitSync.enabled=false \
        --set postgresql.postgresqlPassword=${airflow_postgresql_password} \
        --set postgresql.postgresqlUsername=${airflow_postgresql_user} \
        --set data.metadataConnection.user=${airflow_postgresql_user} \
        --set data.metadataConnection.pass=${airflow_postgresql_password} \
        airflow apache-airflow/airflow \
        --namespace ${NAMESPACE} \
        --debug --version ${HELM_CHART_VERSION} \
        -f -