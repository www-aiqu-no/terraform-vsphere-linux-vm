## =============================================================================
#                                        Deploy Windows VM from vSphere Template
## =============================================================================
resource "vsphere_virtual_machine" "vm" {
  count = "${length(var.hosts)}"
# ------------------------------------------------------------------------------
  annotation                  = "Deployed by HashiCorp Terraform"
  wait_for_guest_net_timeout  = 0
  wait_for_guest_net_routable = false
# ------------------------------------------------------------------------------
  host_system_id   = "${data.vsphere_host.hosts.*.id[count.index]}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
# ------------------------------------------------------------------------------
  guest_id  = "${data.vsphere_virtual_machine.template.guest_id}"
  firmware  = "${data.vsphere_virtual_machine.template.firmware}"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"
# ------------------------------------------------------------------------------
  name     = "${var.name}${count.index}"
  folder   = "${var.vsphere_folder}"
  memory   = "${var.ram_mb}"
  num_cpus = "${var.cpu}"
# ------------------------------------------------------------------------------
  cpu_hot_add_enabled    = true
  cpu_hot_remove_enabled = true
  memory_hot_add_enabled = true
  boot_delay             = "${var.vsphere_boot_delay}"
# ------------------------------------------------------------------------------
  disk {
    label            = "disk0"
    unit_number      = 0
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
    #-- Ensure requested size is > template size
    size = "${
      var.disk_gb == "" || var.disk_gb < data.vsphere_virtual_machine.template.disks.0.size ?
        data.vsphere_virtual_machine.template.disks.0.size :
      var.disk_gb
    }"
  }
# ------------------------------------------------------------------------------
  network_interface {
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types.0}"
    network_id   = "${data.vsphere_network.network.id}"
  }
# ------------------------------------------------------------------------------
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    linked_clone  = false
    customize {
      timeout      = -1
      linux_options {
        host_name = "${var.name}${count.index}"
        domain    = "${var.dns_domain}"
      }
      network_interface {
        ipv4_address    = "${cidrhost(var.ipv4_network,var.ipv4_address_start + count.index)}"
        ipv4_netmask    = "${element(split("/",var.ipv4_network),1)}"
        dns_domain      = "${var.dns_domain}"
      }
      ipv4_gateway = "${var.ipv4_gateway}"
      dns_server_list = "${var.dns_servers}"
      dns_suffix_list = ["${var.dns_domain}"]

    }
  }
# ------------------------------------------------------------------------------
  custom_attributes = "${var.vsphere_custom_attributes}"
# ------------------------------------------------------------------------------
}
