#!/usr/bin/env bash

<<COMMENT

  Summary:
  The following code will install the AWS command line interface.


  Configure by running the command:

    aws configure

  Use the following setup (note, an admin user may need to create the keys if you don't have access):

      AWS Access Key ID:   (created in IAM dashboard for user)
      AWS Secret Access Key:    (only available the first time the access key is created.)
      Default region name: ap-southeast-2
      Default output format: json


COMMENT


PWD=$(pwd)
mkdir $HOME/.aws
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$HOME/awscliv2.zip"
unzip $HOME/awscliv2.zip
sudo cp -r $PWD/aws/* $HOME/.aws
rm -rf $PWD/aws
sudo bash $HOME/.aws/install --update