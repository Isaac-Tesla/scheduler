#!/usr/bin/env bash


# Export the environment variables from .env
while read line; do export $line; done < .env

aws cloudformation delete-stack \
    --stack-name ${S3_TERRAFORM_STACK_NAME}
