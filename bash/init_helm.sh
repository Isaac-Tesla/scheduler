#!/bin/bash

<<COMMENT

  Summary:
  The following code will install Helm to enable the use of Helm
    charts with Kubernetes.

  Note: This method assumes snap is already installed.

COMMENT


snap install helm --classic
helm repo add stable https://charts.helm.sh/stable
helm repo update