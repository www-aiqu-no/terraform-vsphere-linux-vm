# Define values here for easier maintenance & readability

locals {

  # Do not provide values here in production
  secrets = {
    vsphere_password = "YourSecretPassword"
  }

  vsphere = {
    username     = "username-to-authenticate-with"
    address      = "address.of.vcenter"
    datacenter   = "name-of-datacenter"
    datastore    = "name-of-datastore"
    resourcepool = "VMC1/Resources" # Default for vSphere w/o DRS
    network      = "name-of-network"
    template     = "name-of-vm-template"
  }

  vm = {
    name      = "tfvm"
    instances = 2
    network   = "10.0.0.0/24"
    gateway   = "10.0.0.1"
    ip_start  = 50
    # --
    cpus      = 2
    ram       = 2048
    disk_size = 20
  }
}
# ==============================================================================
#   Deploy VM(s) with module
# ==============================================================================

module "vms" {
  source  = "www-aiqu-no/linux-vm/vsphere"
  version = "0.2.0"
  # --
  datacenter   = local.vsphere.datacenter
  datastore    = local.vsphere.datastore
  resourcepool = local.vsphere.resourcepool
  network      = local.vsphere.network
  template     = local.vsphere.template
  # --
  prefix            = local.vm.name
  instances         = local.vm.instances
  ipv4_network      = local.vm.network
  ipv4_gateway      = local.vm.gateway
  ipv4_address_from = local.vm.ip_start
  # --
  cpu_count    = local.vm.cpus
  memory_mb    = local.vm.ram
  disk_size_gb = local.vm.disk_size
}

# Need to re-define any outputs you want from underlying modules
output "name_to_ip" {
  description = "Names & addresses of deployed nodes"
  sensitive   = false
  value       = module.vms.name_to_ip
}

# ==============================================================================
#   Example provisioning with ansible
# ==============================================================================

resource "null_resource" "provision_vms" {
  count = length(module.vms.id) # Creates a provisioner-resource for each vm

  # Only runs when this string changes (or resource is tainted)
  triggers = {
    id = join(",", module.vms.id)
  }

  # Connect to instance via ssh
  connection {
    type        = "ssh"
    user        = "root"                        # depends on your template
    private_key = file("<path-to-private-key>") # optionally password can be provided
    host        = element(module.vms.ip, count.index)
  }

  # Copy local files to deployed instance
  provisioner "file" {
    source      = "./ansible"
    destination = "/tmp/"
  }

  # Execute ansible playbook
  #   Requires ansible pre-installed on your templates
  #   User must be able to run non-interactive if pivileged actions are used
  #   You can optionally install ansible as part of this remote-exec (or add
  #   another remote-exec prior to this)
  provisioner "remote-exec" {
    inline = [
      "cd /tmp/ansible",
      "ansible-playbook playbook.yml"
    ]
  }
}

# ==============================================================================
#   Providers
# ==============================================================================

terraform {}

provider "vsphere" {
  version = "~> 1.16"
  # --
  vsphere_server       = local.vsphere.address
  user                 = local.vsphere.username
  password             = local.secrets.vsphere_password
  allow_unverified_ssl = true
}
