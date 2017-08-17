.DEFAULT_GOAL := setup

env ?= dev

ENV_DIR = providers/azure/${env}
VAR_FILE = terraform.tfvars

.PHONY: setup
setup:
	@echo "Initiating terraform"
	@cd ${ENV_DIR}; \
		terraform init
	@echo "Done!"

.PHONY: terraform-apply
terraform-apply:
	cd ${ENV_DIR}; \
		terraform apply \
			-var-file=${VAR_FILE} \
			-auto-approve=false \
			.

.PHONY: terraform-destroy
terraform-destroy:
	cd ${ENV_DIR}; \
		terraform destroy \
			-var-file=${VAR_FILE} \
			.
