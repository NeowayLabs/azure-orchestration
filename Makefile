.DEFAULT_GOAL := setup

inventory ?= environments/$(env)
provider-dir = providers/azure/$(env)
tags ?= all
user ?= (shell whoami)
var-file = terraform.tfvars

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	docker_ssh_opts =  -e SSH_AUTH_SOCK=$(SSH_AUTH_SOCK) \
	-v $(SSH_AUTH_SOCK):$(SSH_AUTH_SOCK)
endif
ifeq ($(UNAME_S),Darwin)
	docker_ssh_opts = -v $(HOME)/.ssh:/root/.ssh:ro
endif

base-docker-run = @docker run \
	--rm \
	-e ARM_CLIENT_ID=$(AZURE_CLIENT_ID) \
	-e ARM_CLIENT_SECRET=$(AZURE_CLIENT_SECRET) \
	-e ARM_SUBSCRIPTION_ID=$(AZURE_SUBSCRIPTION_ID) \
	-e ARM_TENANT_ID=$(AZURE_TENANT_ID) \
	-e AZURE_CLIENT_ID=$(AZURE_CLIENT_ID) \
	-e AZURE_CLIENT_SECRET=$(AZURE_CLIENT_SECRET) \
	-e AZURE_SECRET=$(AZURE_CLIENT_SECRET) \
	-e AZURE_SERVICE_PRINCIPAL=$(AZURE_SERVICE_PRINCIPAL) \
	-e AZURE_SUBSCRIPTION_ID=$(AZURE_SUBSCRIPTION_ID) \
	-e AZURE_TENANT=$(AZURE_TENANT_ID) \
	-e AZURE_TENANT_ID=$(AZURE_TENANT_ID) \
	-v $(shell pwd):/azure-orchestration \
	$(docker_ssh_opts) \

ansible-docker-run = $(base-docker-run) \
	-w  /azure-orchestration/ansible \
	-it azure-orchestration

terraform-docker-run = $(base-docker-run) \
	-v $(HOME)/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub:ro \
	-w  /azure-orchestration/terraform/$(provider-dir) \
	-it azure-orchestration

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Variable '$*' not set"; \
		exit 1; \
	fi

.PHONY: ansible-playbook
ansible-playbook: guard-env guard-playbook
	$(ansible-docker-run) \
		ansible-playbook $(playbook).yml \
			-c ssh \
			-e 'env=$(env)' \
			-i $(inventory) \
			-t $(tags) \
			-u $(user) \
			-vvv \
			$(ansible-args)

.PHONY: ansible-refresh-cache
ansible-refresh-cache: guard-env
	$(base-docker-run) \
		-w /azure-orchestration/ansible/environments/$(env) \
		-it azure-orchestration \
		python azure_rm.py --refresh-cache --pretty

.PHONY: bash
bash:
	$(base-docker-run) -it azure-orchestration /bin/bash

.PHONY: terraform-apply
terraform-apply: guard-env
	$(terraform-docker-run) \
		terraform apply \
			-auto-approve=false \
			-parallelism=100 \
			-var-file=${var-file} \
			$(terraform-args) \
			.

.PHONY: terraform-destroy
terraform-destroy:
	$(terraform-docker-run) \
		terraform destroy \
		-parallelism=100 \
		$(terraform-args) \
		.

.PHONY: terraform-init
terraform-init: guard-env
	$(terraform-docker-run) terraform init .

.PHONY: setup
setup:
	@echo "Updating submodules"
	git submodule update --init --recursive
	@echo "Building docker image"
	docker build . -t azure-orchestration
	@echo "Done!"
