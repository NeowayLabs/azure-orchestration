# Azure Orchestration

## Prerequisites

 1. [Docker](https://docs.docker.com/engine/installation/)

### Credentials

[Create Azure Service Principal](https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html) then export the credentials.

```bash
$ export AZURE_CLIENT_ID=YOUR_AZURE_CLIENT_ID
$ export AZURE_CLIENT_SECRET=YOUR_AZURE_CLIENT_SECRET
$ export AZURE_SERVICE_PRINCIPAL=YOUR_AZURE_SERVICE_PRINCIPAL
$ export AZURE_SUBSCRIPTION_ID=YOUR_AZURE_SUBSCRIPTION_ID
$ export AZURE_TENANT_ID=YOUR_AZURE_TENANT_ID
```

## Getting Started

First of all setup the development environment:

```console
$ make setup
```

This project orchestrates multiple environments. By default, commands will rely on `dev` when applied and not specified. These are the environments available:

- `dev` (default)
- `stg`


### Provisioning

__Important note:__ Each terraform.tfvars for an enviroment has a variable `trusted_ip`. 
It determines an IP address to allow inbound ssh into virtual machines. Make sure you set it to a secure ip address.

Create the `dev` environment:

 1. For the very first time and every new module you must initialize the Terraform.

    ```console
    $ make terraform-init env=dev
    ```

 1. Apply Terraform to create the infrastructure. Make sure you acknowledge the execution plan before you apply the changes.

    ```console
    $ make terraform-apply env=dev
    ```

### Configuring

Configure the `dev` environment:

 1. Run ansible playbook to cargo virtual machines.

    ```console
    $ make ansible-playbook env=dev playbook=cargo
    ```
