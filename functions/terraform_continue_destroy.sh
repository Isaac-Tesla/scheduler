#!/bin/bash

<<COMMENT

  Summary:
  The following function prompts the user if they wish to continue.

COMMENT


terraform_continue_destroy () {

  read -p "***Are you absolutely sure you want to tear it down? (y/n) " RESP
  if [ "$RESP" = "y" ]; then
    echo "***Continuing with destroying..."
  else
    printf "***Stopping now!"
    exit 1
  fi

}