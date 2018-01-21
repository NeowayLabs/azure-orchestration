terraform {
  required_version = ">= 0.11.2"
}

provider "azurerm" {
  version = "~> 1.0.1"
}

module "network" {
  source = "../../../modules/network"

  env      = "${var.env}"
  location = "${var.location}"

  address_space = "${var.address_space}"
}

module "cargo" {
  source = "../../../modules/cargo"

  env      = "${var.env}"
  location = "${var.location}"

  platform_fault_domain_count         = "${var.cargo_platform_fault_domain_count}"
  platform_update_domain_count        = "${var.cargo_platform_update_domain_count}"
  trusted_ip                          = "${var.trusted_ip}"
  subnet_address_prefix               = "${var.cargo_subnet_address_prefix}"
  virtual_machine_admin_password      = "${var.cargo_virtual_machine_admin_password}"
  virtual_machine_admin_username      = "${var.cargo_virtual_machine_admin_username}"
  virtual_machine_count               = "${var.cargo_virtual_machine_count}"
  virtual_machine_size                = "${var.cargo_virtual_machine_size}"
  virtual_network_name                = "${module.network.name}"
  virtual_network_resource_group_name = "${module.network.resource_group_name}"
}

output "cargo_fqdn" {
  value = "${module.cargo.fqdn}"
}
