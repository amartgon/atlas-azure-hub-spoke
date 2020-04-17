# Test of Atlas Peering with Hub&Spoke Architecture on Azure
The purpose of this Terraform project is testing Atlas peering in an [Azure Hub&Spoke Architecture](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke).

In particular, connectivity from a spoke (spoke 1) to Atlas is enabled withouth a direct peering through a virtual machine in the hub configured to act as router and perform NAT.

### Code organization:
Terraform code is largely based on these two sources:
- https://docs.microsoft.com/en-us/azure/terraform/terraform-hub-spoke-validation
- Eugene Bogaart's Azure Peering with Terraform demo (https://github.com/eugenebogaart/Atlas-Azure-Peering)

Description of the project files:
- `main.tf`: just declares the required Terraform providers and versions
- `variables.tf`: variables that need to be before running terraform
- `onprem.tf`: vnet and virtual machine that simulates on-premises infrastructure (address space 10.2.0.0/16)
- `hub-vnet.tf`: definition of the hub vnet (10.0.0.0/16) containing a vm with mongo client installed
- `spoke1.tf`: definition of a spoke vnet (address space 10.1.0.0/16) containing a vm with mongo client installed
- `atlas.tf`: create an Atlas project, a cluster and a peering with the hub (Atlas CIDR 192.168.248.0/21).
- `hub-nva.tf`: definition of the router vm (in the hub) and user defined routes.
The router uses iptables to perform NAT. The key configuration command is:
```
sudo iptables -t nat -A POSTROUTING -j MASQUERADE -s 10.1.0.0/16 -d 192.168.248.0/21
```

### Instructions to test connectivity

1. Set appropriate values in variables.tf
2. Run `terraform apply` (the project has been tested in Azure Cloud Shell, running on an local Terraform deployment might require some adjustment).
3. In the Azure Portal, check the public IP of virtual machine 'onprem-vm'. Log into it with ssh and the user and passord configured in `variables.tf`.
4. From there, ssh virtual machine 'spoke1-mongoclient-vm'. This machine has the mongo shell installed, use it to test connectivity with the connection string provided by Atlas.
