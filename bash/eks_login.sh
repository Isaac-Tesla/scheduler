#!/usr/bin/env bash

<< COMMENT

  Summary: Displays the token to connect to the cluster.

COMMENT


### LOGIN
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep service-controller-token | awk '{print $1}')
echo "go to http://127.0.0.1:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
kubectl proxy
