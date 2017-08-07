.DEFAULT_GOAL := setup

env ?= dev
inventory ?= environments/$(env)
tags ?= all
user ?= core

.PHONY: bootstrap
bootstrap:
	source .venv-ansible/bin/activate && \
	ansible-playbook bootstrap.yml \
		-i $(inventory) \
		-l $(hosts) \
		-vvv

.PHONY: cargo
cargo:
	source .venv-ansible/bin/activate && \
	ansible-playbook cargo.yml \
		-i $(inventory) \
		-t $(tags) \
		-vvv

.PHONY: remote-shell
remote-shell:
	source .venv-ansible/bin/activate && \
	ansible $(hosts) \
		-i $(inventory) \
		-m shell \
		-b \
		-u $(user) \
		-e 'ansible_python_interpreter=/home/core/bin/python' \
		-a "$(shell)" \
		$(ansible-args)

.PHONY: setup
setup:
	pip install --user virtualenv
	virtualenv .venv-ansible
	source .venv-ansible/bin/activate && \
		pip install -r requirements.txt
