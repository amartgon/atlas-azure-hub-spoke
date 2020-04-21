

locals {
  # New empty Atlas project name to create in organization
  project_id            = "azure-peering-test"
  # Atlas Pulic providor
  provider_name         = "AZURE"
  # Atlas cidr block
  atlas_cidr_block      = "192.168.248.0/21"
}


# Need a project
resource "mongodbatlas_project" "proj1" {
  name   = local.project_id
  org_id = var.atlas_organization_id
}

resource "mongodbatlas_network_container" "test" {
  project_id       = mongodbatlas_project.proj1.id
  atlas_cidr_block = local.atlas_cidr_block
  provider_name    = local.provider_name
  region           = var.atlas_region
  provisioner "local-exec" {
    command = "./setup-role.sh ${data.azurerm_subscription.current.subscription_id} ${azurerm_resource_group.hub-vnet-rg.name} ${azurerm_virtual_network.hub-vnet.name}  >> setup-role.output"
  }
}


# Peering for project Project
resource "mongodbatlas_network_peering" "test" {
  project_id            = mongodbatlas_project.proj1.id
  atlas_cidr_block      = local.atlas_cidr_block
  container_id          = mongodbatlas_network_container.test.container_id
  provider_name         = local.provider_name
  azure_directory_id    = data.azurerm_subscription.current.tenant_id
  azure_subscription_id = data.azurerm_subscription.current.subscription_id
  resource_group_name   = azurerm_resource_group.hub-vnet-rg.name
  vnet_name             = azurerm_virtual_network.hub-vnet.name

}


resource "mongodbatlas_project_ip_whitelist" "test" {
    project_id = mongodbatlas_project.proj1.id
    cidr_block = azurerm_virtual_network.hub-vnet.address_space[0]
    comment    = "cidr block Azure subnet1"
}

resource "mongodbatlas_cluster" "this" {
  name                  = "example"
  project_id            = mongodbatlas_project.proj1.id

  replication_factor           = 3
  backup_enabled               = true
  auto_scaling_disk_gb_enabled = true
  mongo_db_major_version       = "4.0"

  provider_name               = local.provider_name
  provider_instance_size_name = "M10"
  # this provider specific, why?
  provider_region_name        = var.atlas_region

  depends_on = [ mongodbatlas_network_peering.test ]
}


resource "mongodbatlas_database_user" "user" {
  username           = var.username
  password           = var.password
  project_id         = mongodbatlas_project.proj1.id
  auth_database_name = "admin"

  roles {
    role_name     = "atlasAdmin"
    database_name = "admin"
  }
}