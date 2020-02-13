# ==============================================================================
#   Resource(s)
# ==============================================================================
resource "vsphere_virtual_machine" "vm" {
  count = length(var.host_system_id) != 0 ? length(var.host_system_id) : var.instances
  name  = join("", [var.prefix, count.index])
  # ----------------------------------------------------------------------------
  #   vSphere resources
  # ----------------------------------------------------------------------------
  resource_pool_id = data.vsphere_resource_pool.resourcepool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = length(var.host_system_id) != 0 ? var.host_system_id[count.index] : null
  folder           = var.folder
  # ----------------------------------------------------------------------------
  #   VM options
  # ----------------------------------------------------------------------------
  guest_id             = data.vsphere_virtual_machine.template.guest_id
  firmware             = data.vsphere_virtual_machine.template.firmware
  alternate_guest_name = data.vsphere_virtual_machine.template.alternate_guest_name
  annotation           = var.annotation
  # ----------------------------------------------------------------------------
  #   Boot options
  # ----------------------------------------------------------------------------
  boot_delay              = var.boot_delay
  efi_secure_boot_enabled = var.efi_secure_boot_enabled
  boot_retry_delay        = var.boot_retry_delay
  boot_retry_enabled      = var.boot_retry_enabled
  # ----------------------------------------------------------------------------
  #   CPU and memory options
  # ----------------------------------------------------------------------------
  num_cpus               = var.cpu_count
  num_cores_per_socket   = var.cpu_cores_per_socket
  cpu_hot_add_enabled    = var.cpu_hot_add_enabled
  cpu_hot_remove_enabled = var.cpu_hot_remove_enabled
  memory                 = var.memory_mb
  memory_hot_add_enabled = var.memory_hot_add_enabled
  # ----------------------------------------------------------------------------
  cpu_limit          = var.cpu_limit
  cpu_reservation    = var.cpu_reservation
  cpu_share_level    = var.cpu_share_level
  cpu_share_count    = var.cpu_share_count
  memory_limit       = var.memory_limit
  memory_reservation = var.memory_reservation
  memory_share_level = var.memory_share_level
  memory_share_count = var.memory_share_count
  # ----------------------------------------------------------------------------
  #   Network interface options
  # ----------------------------------------------------------------------------
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    # --
    use_static_mac        = var.use_static_mac
    mac_address           = var.mac_address
    bandwidth_limit       = var.bandwidth_limit
    bandwidth_reservation = var.bandwidth_reservation
    bandwidth_share_level = var.bandwidth_share_level
    bandwidth_share_count = var.bandwidth_share_count
  }
  # ----------------------------------------------------------------------------
  #  Disk options
  # ----------------------------------------------------------------------------
  scsi_controller_count = 1
  scsi_type             = data.vsphere_virtual_machine.template.scsi_type
  scsi_bus_sharing      = data.vsphere_virtual_machine.template.scsi_bus_sharing
  enable_disk_uuid      = var.enable_disk_uuid
  # ----------------------------------------------------------------------------
  disk {
    unit_number       = var.disk_unit_number
    label             = var.disk_label
    size              = var.disk_size_gb != null ? var.disk_size_gb : data.vsphere_virtual_machine.template.disks[0].size
    eagerly_scrub     = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
    thin_provisioned  = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
    attach            = var.disk_attach
    path              = var.disk_path
    keep_on_remove    = var.disk_keep_on_remove
    disk_mode         = var.disk_mode
    disk_sharing      = var.disk_sharing
    write_through     = var.disk_write_through
    io_limit          = var.disk_io_limit
    io_reservation    = var.disk_io_reservation
    io_share_level    = var.disk_io_share_level
    io_share_count    = var.disk_io_share_count
    storage_policy_id = var.disk_storage_policy_id
  }
  # ----------------------------------------------------------------------------
  #  CDROM options
  # ----------------------------------------------------------------------------
  #cdrom {
  #  client_device = var.cdrom_client_device
  #  datastore_id  = var.cdrom_datastore_id
  #  path          = var.cdrom_path
  #}
  # ----------------------------------------------------------------------------
  #  Cloning options (template)
  # ----------------------------------------------------------------------------
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    linked_clone  = var.clone_linked
    timeout       = var.clone_timeout_total # minutes

    customize {
      timeout = var.clone_timeout_customize # minutes
      # Linux customization options
      linux_options {
        host_name    = var.hostname_override != null ? var.hostname_override : join("", [var.prefix, count.index])
        domain       = var.dns_domain != null ? var.dns_domain : "localdomain"
        hw_clock_utc = var.hw_clock_utc
        time_zone    = var.timezone
      }

      # Match order with 'outer' interface(s)
      dns_server_list = var.dns_servers
      dns_suffix_list = var.dns_suffix_list
      ipv4_gateway    = var.ipv4_gateway
      ipv6_gateway    = null
      network_interface {
        ipv4_address = cidrhost(var.ipv4_network, var.ipv4_address_from + count.index)
        ipv4_netmask = element(split("/", var.ipv4_network), 1)
        dns_domain   = var.dns_domain
        ipv6_address = null
        ipv6_netmask = null
      }
    }
  }
  # ----------------------------------------------------------------------------
  #  VMware Tools options
  # ----------------------------------------------------------------------------
  sync_time_with_host                     = var.sync_time_with_host
  run_tools_scripts_after_power_on        = var.run_tools_scripts_after_power_on
  run_tools_scripts_after_resume          = var.run_tools_scripts_after_resume
  run_tools_scripts_before_guest_reboot   = var.run_tools_scripts_before_guest_reboot
  run_tools_scripts_before_guest_shutdown = var.run_tools_scripts_before_guest_shutdown
  run_tools_scripts_before_guest_standby  = var.run_tools_scripts_before_guest_standby
  # ----------------------------------------------------------------------------
  #  Advanced options
  # ----------------------------------------------------------------------------
  hv_mode           = var.hv_mode
  ept_rvi_mode      = var.ept_rvi_mode
  nested_hv_enabled = var.nested_hv_enabled
  # ----------------------------------------------------------------------------
  enable_logging                   = var.enable_logging
  cpu_performance_counters_enabled = var.cpu_performance_counters_enabled
  swap_placement_policy            = var.swap_placement_policy
  latency_sensitivity              = var.latency_sensitivity
  # ----------------------------------------------------------------------------
  wait_for_guest_net_timeout  = var.wait_for_guest_net_timeout
  wait_for_guest_net_routable = var.wait_for_guest_net_routable
  wait_for_guest_ip_timeout   = var.wait_for_guest_ip_timeout
  ignored_guest_ips           = var.ignored_guest_ips
  # ----------------------------------------------------------------------------
  shutdown_wait_timeout = var.shutdown_wait_timeout
  migrate_wait_timeout  = var.migrate_wait_timeout
  force_power_off       = var.force_power_off
  # ----------------------------------------------------------------------------
  #  Other options
  # ----------------------------------------------------------------------------
  custom_attributes = var.custom_attributes
  tags              = var.tags
  extra_config      = {} # TODO
}

# ==============================================================================
#  Datasource(s)
# ==============================================================================

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_resource_pool" "resourcepool" {
  name          = var.resourcepool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "hosts" {
  count         = length(var.host_system_id)
  name          = element(var.host_system_id, count.index)
  datacenter_id = data.vsphere_datacenter.dc.id
}
