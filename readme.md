# Scheduler

The EKS cluster is a slightly cleaned up version of one found online, but not to the point of fixing all of the code flaws (e.g. "this" everywhere).

To show commands setup, run "make".

</br>

# Deployment steps

Overview:        
1. Setup AWS Cli tool + Helm + Kubectl
2. Add environment variables
3. S3 for backend
4. Terraform EKS
5. Setup EKS
6. Deploy Airflow

</br>

# Commands      

1. Setup AWS Cli tool + Helm + Kubectl

```
./bash/init_aws.sh

./bash/init_helm.sh

sudo apt install -y \
    make

sudo snap install kubectl \
    --channel=1.20/stable \
    --classic


If already installed, refresh with:

    sudo snap refresh kubectl \
        --channel=1.20/stable \
        --classic
```

</br>

2. Add environment variables

```
cp .env.sample .env
```

Add the correct settings you need.


</br>

3. S3 for backend

```
make s3
```

</br>

4. Terraform EKS

```
make eks
```

</br>

5. Setup EKS and Kubectl

```
Add the correct cluster name here after it is created.0

    CLUSTER_NAME=<cluster-name>
    REGION=ap-southeast-2

aws sts get-caller-identity

aws eks update-kubeconfig \
  --region ${REGION} \
  --name ${CLUSTER_NAME}

test / confirm

    kubectl get svc


Add metrics server and Dashboard:

    kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

    kubectl get deployment metrics-server -n kube-system

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.4.0/aio/deploy/recommended.yaml

    kubectl apply -f ./terraform/eks/kubernetes-dashboard-admin.rbac.yaml

```

</br>

6. Deploy Airflow

```
make airflow
```


# Port Forward Airflow dashboard

```
make airflow_pf
```


# Cleanup

Run:

```
make eks_down
```