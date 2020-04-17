provider "azurerm" {
  # whilst the `version` attribute is optional,
  # we recommend pinning to a given version of the Provider
  # version = "=1.36.0"
  version = "=2.1"
  features {}
}


provider "mongodbatlas" {
  public_key = var.atlas_public_key
  private_key  = var.atlas_private_key
  version = "~> 0.3"
}


data "azurerm_subscription" "current" {
}
