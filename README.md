# Create Linux VM scaleset on vSphere
![GitHub top language](https://img.shields.io/github/languages/top/www-aiqu-no/terraform-vsphere-linux-vm)
![GitHub Workflow Status](https://img.shields.io/github/workflow/status/www-aiqu-no/terraform-vsphere-linux-vm/terraform-validate)
![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/www-aiqu-no/terraform-vsphere-linux-vm?include_prereleases)
![GitHub last commit](https://img.shields.io/github/last-commit/www-aiqu-no/terraform-vsphere-linux-vm)
![GitHub issues](https://img.shields.io/github/issues/www-aiqu-no/terraform-vsphere-linux-vm)

# Limitations
- Single disk & datastore
- Single NIC
- Only ipv4

# Example (incl. provisioning)
```hcl
# See under example/ for a better & more detailed example
# --
# Deploy nodes
module "cluster" {
  source  = "www-aiqu-no/linux-vm/vsphere"
  version = "0.2.0"
  # --
  datacenter   = "example-ds"
  datastore    = "example-ds"
  resourcepool = "VMC1/Resources"
  network      = "example-nw"
  template     = "example-tpl"
  # --
  prefix            = "demo"
  instances         = 2
  ipv4_network      = "10.0.0.0/24"
  ipv4_gateway      = "10.0.0.1"
  ipv4_address_from = 50
  # --
  cpu_count    = 2
  memory_mb    = 4096
  disk_size_gb = 50
}
```
