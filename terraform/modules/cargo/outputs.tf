output "load_balancer_public_ip_address" {
  value = "${azurerm_public_ip.pubip.ip_address}"
}
