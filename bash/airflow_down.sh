#!/usr/bin/env bash

NAMESPACE=airflow
helm uninstall airflow -n $NAMESPACE
