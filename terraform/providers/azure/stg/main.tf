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
