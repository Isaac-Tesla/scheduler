#!/bin/bash


<<COMMENT

   Checks the namespace within Kubernetes, if it 
     doesn't exist, creates it. This assumes the 
     current logged in Kubernetes Cluster is set.

   Use:
     create_namespace  <NAMESPACE>

COMMENT


function create_namespace () {

   local NAMESPACE=$1
   local NS=$(kubectl get namespace $NAMESPACE --ignore-not-found);
   if [[ "$NS" ]]; then
      echo "Namespace $NAMESPACE already exists!";
   else
      kubectl create namespace $NAMESPACE;
   fi;

}