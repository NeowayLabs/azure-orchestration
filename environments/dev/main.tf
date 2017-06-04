module "network" {
  source = "../../modules/network"

  env      = "${var.env}"
  location = "${var.location}"

  address_space               = "${var.address_space}"
  cargo_subnet_address_prefix = "${var.cargo_subnet_address_prefix}"
}

module "cargo" {
  source = "../../modules/cargo"

  env      = "${var.env}"
  location = "${var.location}"

  platform_fault_domain_count  = "${var.platform_fault_domain_count}"
  platform_update_domain_count = "${var.platform_update_domain_count}"
}
