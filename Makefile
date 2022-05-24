.PHONY: help
help:
	@cat $(MAKEFILE_LIST) \
		| grep -e "^[a-zA-Z0-9_\-]*: *.*## *" \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

init: ## Setup the AWS Cli tool
	sudo ./scripts/init_aws.sh

s3: ## Setup the S3 bucket to store the Terraform state file
	./bash/s3_up.sh

s3_down: ## Tear down the S3 bucket that stores the Terraform state file
	./bash/s3_down.sh

eks: ## Setup Kubernetes
	./bash/eks_up.sh

eks_down: ## Tear down Kubernetes
	./bash/eks_down.sh

eks_login: ## Tear down Kubernetes
	./bash/eks_login.sh

airflow: ## Setup Airflow
	./bash/airflow_up.sh

airflow_down: ## Tear down Airflow
	./bash/airflow_down.sh