variable "location" {
  description = "Location of the network"
  default     = "centralus"
}

#Used both for login to Linux servers and MongoDB user in Atlas
variable "username" {
  description = "Username for Virtual Machines"
  default     = "testadmin"
}

#Used both for login to Linux servers and MongoDB user in Atlas
variable "password" {
  description = "Password for Virtual Machines"
  default     = "Password1234"
}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_A1_v2"
}


#Atlas API keys for Atlas Terraform provider
variable "atlas_public_key" {
  default     = "[YOUR VALUE HERE]"
}

variable "atlas_private_key" {
  default     = "[YOUR VALUE HERE]"
}

variable "atlas_organization_id" {
  description = "Atlas org where the new project will be created"
  default     = "[YOUR VALUE HERE]"
}

# Atlas region, https://docs.atlas.mongodb.com/reference/microsoft-azure/#microsoft-azure
variable "atlas_region" {
  default     = "US_CENTRAL"
}

