#!/bin/bash

<<COMMENT

  Summary:
  The following function prompts the user if they wish to 
    continue with a displayed Terraform plan.

COMMENT


terraform_continue () {

  read -p "***Do you wish to continue with the Terraform plan? (y/n) " RESP
  if [ "$RESP" = "y" ]; then
    echo "Continuing..."
  else
    printf "Stopped."
    exit 1
  fi

}