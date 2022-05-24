#!/usr/bin/env bash


# Export the environment variables from .env
while read line; do export $line; done < .env

BUCKET_NAME=${BUCKET_NAME} \
  envsubst < ./cloudformation/s3.yaml > s3_env.yaml

aws cloudformation deploy \
        --stack-name ${S3_TERRAFORM_STACK_NAME} \
        --template-file s3_env.yaml

rm s3_env.yaml