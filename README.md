# Azure Orchestration

## Prerequisites

 1. [Azure CLI](https://docs.microsoft.com/cs-cz/cli/azure/install-azure-cli)

 1. [Docker](https://docs.docker.com/engine/installation/)

 1. [Terraform](https://www.terraform.io/intro/getting-started/install.html)

### Credentials

Ansible and Terraform don't agree in which key to use to specify a value of a credential. Example: Ansible looks at `AZURE_SECRET` and Terraform looks at `ARM_CLIENT_SECRET` to get the secret of a service principal.

There are other ways to expose credentials to both tools. I recommend that you use environment variables but feel free to pick whatever you want.

 1. Terraform [instructions](https://www.terraform.io/docs/providers/azurerm/index.html#creating-credentials) will help with the creation of Azure credentials and so exporting them to your environment.

 1. Once you have created the credentials follow Ansible [instructions](https://docs.ansible.com/ansible/2.3/guide_azure.html) to export them to your environment.

## Getting Started

First of all setup the development environment:

```console
$ make setup
```

This project orchestrates multiple environments. By default, commands will rely on `dev` when applied and not specified. These are the environments available:

- `dev` (default)
- `stg`
- `prd`


### Provisioning

__Important note:__ Each terraform.tfvars for an enviroment has a variable `trusted_ip`. 
It determines an IP address to allow inbound ssh on a virtual machine. Make sure you set it to a secure ip address. (NOT GOOD IDEA) Or leave it open to the internet (:boom:).

Create the `dev` environment:

 1. Step into `terraform` directory.

    ```console
    $ cd terraform
    ```

 1. Generate an execution plan for Terraform and make sure you acknowledge the execution plan before you apply the changes.

    ```console
    $ make terraform-plan env=dev
    ```

 1. Apply Terraform to create the infrastructure.

    ```console
    $ make terraform-apply
    ```

### Configuring

Configure the `dev` environment:

 1. Step into `ansible` directory.

    ```console
    $ cd ansible
    ```

 1. Setup ansible requirements with docker.

    ```console
    $ make docker-build
    ```

 1. Apply ansible playbook to cargo virtual machines.

    ```console
    $ make cargo
    ```
