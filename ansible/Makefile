.DEFAULT_GOAL := docker-build

env ?= dev
inventory ?= environments/$(env)
tags ?= all
user ?= core

docker_run = docker run \
	--rm \
	--name ansible-azure \
	-e AZURE_CLIENT_ID=$(AZURE_CLIENT_ID) \
	-e AZURE_SECRET=$(AZURE_SECRET) \
	-e AZURE_SUBSCRIPTION_ID=$(AZURE_SUBSCRIPTION_ID) \
	-e AZURE_TENANT=$(AZURE_TENANT) \
	-v ~/.ssh:/root/.ssh \
	-v $(PWD):/ansible \
	-w  /ansible \
	-it ansible-azure

.PHONY: bootstrap
bootstrap:
	$(docker_run) \
		ansible-playbook bootstrap.yml \
			-i $(inventory) \
			-l $(hosts) \
			-vvv

.PHONY: cargo
cargo:
	$(docker_run) \
		ansible-playbook cargo.yml \
			-i $(inventory) \
			-t $(tags) \
			-vvv

.PHONY: remote-shell
remote-shell:
	$(docker_run) \
		ansible $(hosts) \
			-i $(inventory) \
			-m shell \
			-b \
			-u $(user) \
			-e 'ansible_python_interpreter=/home/core/bin/python' \
			-a "$(shell)" \
			$(ansible-args)

.PHONY: docker-build
docker-build:
	docker build . -t ansible-azure
