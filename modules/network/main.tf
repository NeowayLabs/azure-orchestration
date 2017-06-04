resource "azurerm_resource_group" "rg" {
  name     = "${var.env}-network-rg"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.env}-network"
  location            = "${var.location}"
  address_space       = "${var.address_space}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  subnet {
    name           = "${var.env}-cargo-subnet"
    address_prefix = "${var.cargo_subnet_address_prefix}"
  }
}
