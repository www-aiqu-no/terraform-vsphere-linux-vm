# ==============================================================================
#   REQUIRED
# ==============================================================================

variable "datacenter" {
  type        = string
  description = "Target vSphere datacenter"
}

variable "datastore" {
  type        = string
  description = "Target vSphere datastore"
}

variable "network" {
  type        = string
  description = "Target vSphere network"
}

variable "template" {
  type        = string
  description = "Target vSphere template"
}

# ==============================================================================
#   OPTIONAL
# ==============================================================================

variable "prefix" {
  type        = string
  default     = "vm"
  description = "Prefix used for naming the node(s) in vSphere and setting hostname"
}

variable "instances" {
  type        = number
  default     = 1
  description = "Number of nodes to create. This value is not used if 'host_system_id' is used"
}

variable "host_system_id" {
  type        = list
  default     = []
  description = "Manually place the nodes on hosts. This will override the number specified in 'instances'"
}

variable "resourcepool" {
  type        = string
  default     = "VMC1/Resources"
  description = "Target vSphere resource pool."
}

variable "folder" {
  type        = string
  default     = null
  description = "Existing vSphere folder to place the vm inside."
}

# --

variable "firmware" {
  type        = string
  default     = "bios"
  description = "The firmware interface to use on the virtual machine. Can be one of bios or EFI."
}

variable "annotation" {
  type        = string
  default     = "Deployed by terraform"
  description = "A user-provided description of the virtual machine."
}
# --
variable "boot_delay" {
  type        = number
  default     = 5000
  description = "The number of milliseconds to wait before starting the boot sequence."
}

variable "efi_secure_boot_enabled" {
  type        = bool
  default     = false
  description = "When the firmware type is set to is efi, this enables EFI secure boot."
}

variable "boot_retry_delay" {
  type        = number
  default     = 10000
  description = "The number of milliseconds to wait before retrying the boot sequence. This only valid if boot_retry_enabled is true."
}

variable "boot_retry_enabled" {
  type        = bool
  default     = false
  description = "If set to true, a virtual machine that fails to boot will try again after the delay defined in boot_retry_delay."
}

#--

variable "cpu_count" {
  type        = number
  default     = 1
  description = "The total number of virtual processor cores to assign to this virtual machine."
}
variable "cpu_cores_per_socket" {
  type        = number
  default     = 1
  description = "The number of cores per socket in this virtual machine. The number of vCPUs on the virtual machine will be the number of cpus divided by cores-per-socket. If specified, the value supplied to cpu_count must be evenly divisible by this value."
}

variable "cpu_hot_add_enabled" {
  type        = bool
  default     = null
  description = "Allow CPUs to be added to this virtual machine while it is running."
}

variable "cpu_hot_remove_enabled" {
  type        = bool
  default     = null
  description = "Allow CPUs to be removed to this virtual machine while it is running."
}

variable "memory_mb" {
  type        = number
  default     = 1024
  description = "The size of the virtual machine's memory, in MB"
}

variable "memory_hot_add_enabled" {
  type        = bool
  default     = null
  description = "Allow memory to be added to this virtual machine while it is running."
}

variable "cpu_limit" {
  type        = number
  default     = -1
  description = "The maximum amount of CPU (in MHz) that this virtual machine can consume, regardless of available resources."
}

variable "cpu_reservation" {
  type        = number
  default     = null
  description = "The amount of CPU (in MHz) that this virtual machine is guaranteed."
}

variable "cpu_share_level" {
  type        = string
  default     = "normal"
  description = "The allocation level for CPU resources. Can be one of high, low, normal, or custom."
}

variable "cpu_share_count" {
  type        = number
  default     = null
  description = "The number of CPU shares allocated to the virtual machine when the cpu_share_level is custom."
}

variable "memory_limit" {
  type        = number
  default     = -1
  description = "The maximum amount of memory (in MB) that this virtual machine can consume, regardless of available resources."
}

variable "memory_reservation" {
  type        = number
  default     = null
  description = "The amount of memory (in MB) that this virtual machine is guaranteed."
}

variable "memory_share_level" {
  type        = string
  default     = "normal"
  description = "The allocation level for memory resources. Can be one of high, low, normal, or custom."
}

variable "memory_share_count" {
  type        = number
  default     = null
  description = "The number of memory shares allocated to the virtual machine when the memory_share_level is custom."
}

# --

variable "ipv4_network" {
  type        = string
  default     = null
  description = "The IPv4 network assigned to this node, including netmask."
}

variable "ipv4_address_from" {
  type        = number
  default     = null
  description = "The first IPv4 address for nodes in the scaleset."
}

variable "ipv4_gateway" {
  type        = string
  default     = null
  description = "The IPv4 default gateway when using network_interface customization on the virtual machine."
}

variable "dns_domain" {
  type        = string
  default     = "local"
  description = "The domain name for this machine. This, along with hostname, make up the FQDN of this virtual machine."
}

variable "dns_servers" {
  type        = list
  default     = ["1.1.1.1", "1.0.0.1", "8.8.8.8", "8.8.4.4"]
  description = "The list of DNS servers to configure on a virtual machine."
}

variable "dns_suffix_list" {
  type        = list
  default     = null
  description = "A list of DNS search domains to add to the DNS configuration on the virtual machine."
}

# --

variable "use_static_mac" {
  type        = bool
  default     = false
  description = "If true, the mac_address field is treated as a static MAC address and set accordingly. Setting this to true requires mac_address to be set."
}

variable "mac_address" {
  type        = string
  default     = null
  description = "The MAC address of this network interface. Can only be manually set if use_static_mac is true, otherwise this is a computed value that gives the current MAC address of this interface."
}

variable "bandwidth_limit" {
  type        = number
  default     = null
  description = "The upper bandwidth limit of this network interface, in Mbits/sec."
}

variable "bandwidth_reservation" {
  type        = number
  default     = null
  description = "The bandwidth reservation of this network interface, in Mbits/sec."
}

variable "bandwidth_share_level" {
  type        = string
  default     = "normal"
  description = "The bandwidth share allocation level for this interface. Can be one of low, normal, high, or custom."
}

variable "bandwidth_share_count" {
  type        = number
  default     = null
  description = "The share count for this network interface when the share level is custom."
}

# --

variable "enable_disk_uuid" {
  type        = bool
  default     = false
  description = "Expose the UUIDs of attached virtual disks to the virtual machine, allowing access to them in the guest."
}

variable "disk_uuid" {
  default = null
}

variable "disk_label" {
  default = "disk0"
}

variable "disk_size_gb" {
  type        = number
  default     = null
  description = "The size of the disk, in GB."
}

variable "disk_unit_number" {
  type        = string
  default     = 0
  description = "The disk number on the SCSI bus."
}

variable "disk_attach" {
  type        = bool
  default     = null
  description = "Attach an external disk instead of creating a new one. Implies and conflicts with keep_on_remove. If set, you cannot set size, eagerly_scrub, or thin_provisioned. Must set path if used."
}

variable "disk_path" {
  type        = string
  default     = null
  description = "When using attach, this parameter controls the path of a virtual disk to attach externally. Otherwise, it is a computed attribute that contains the virtual disk's current filename."
}

variable "disk_keep_on_remove" {
  type        = bool
  default     = false
  description = "Keep this disk when removing the device or destroying the virtual machine."
}

variable "disk_mode" {
  type        = string
  default     = "persistent"
  description = "The mode of this this virtual disk for purposes of writes and snapshotting. Can be one of append, independent_nonpersistent, independent_persistent, nonpersistent, persistent, or undoable."
}

variable "disk_sharing" {
  type        = string
  default     = "sharingNone"
  description = "The sharing mode of this virtual disk. Can be one of sharingMultiWriter or sharingNone."
}

variable "disk_write_through" {
  type        = bool
  default     = false
  description = "If true, writes for this disk are sent directly to the filesystem immediately instead of being buffered."
}

variable "disk_io_limit" {
  type        = number
  default     = null
  description = "The upper limit of IOPS that this disk can use."
}

variable "disk_io_reservation" {
  type        = number
  default     = null
  description = "The I/O reservation (guarantee) that this disk has, in IOPS. The default is no reservation."
}

variable "disk_io_share_level" {
  type        = string
  default     = "normal"
  description = "The share allocation level for this disk. Can be one of low, normal, high, or custom."
}

variable "disk_io_share_count" {
  type        = number
  default     = null
  description = "The share count for this disk when the share level is custom."
}

variable "disk_storage_policy_id" {
  type        = string
  default     = null
  description = "The UUID of the storage policy to assign to this disk."
}

# --

#variable "cdrom_datastore_id" { default = null }
#variable "cdrom_client_device" { default = null }
#variable "cdrom_path" { default = null }

# --

variable "clone_linked" {
  type        = bool
  default     = false
  description = "Clone this virtual machine from a snapshot. Templates must have a single snapshot only in order to be eligible."
}

variable "clone_timeout_total" {
  type        = number
  default     = 30
  description = "The timeout, in minutes, to wait for the virtual machine clone to complete."
}

variable "clone_timeout_customize" {
  type        = number
  default     = 10
  description = "The time, in minutes that Terraform waits for customization to complete before failing. Setting the value to 0 or a negative value disables the waiter altogether."
}

variable "hostname_override" {
  type        = string
  default     = null
  description = "Override the host name for this machine. This, along with domain, make up the FQDN of this virtual machine."
}

variable "hw_clock_utc" {
  type        = bool
  default     = true
  description = "Tells the operating system that the hardware clock is set to UTC."
}

variable "timezone" {
  type        = number
  default     = 85 # (GMT/UTC)
  description = "The new time zone for the virtual machine. This is a numeric, sysprep-dictated, timezone code."
}

# --

variable "sync_time_with_host" {
  type        = bool
  default     = false
  description = "Enable guest clock synchronization with the host. Requires VMware tools to be installed."
}

variable "run_tools_scripts_after_power_on" {
  type        = bool
  default     = true
  description = "Enable the execution of post-power-on scripts when VMware tools is installed."
}

variable "run_tools_scripts_after_resume" {
  type        = bool
  default     = true
  description = "Enable the execution of post-resume scripts when VMware tools is installed."
}

variable "run_tools_scripts_before_guest_reboot" {
  type        = bool
  default     = false
  description = "Enable the execution of pre-reboot scripts when VMware tools is installed."
}

variable "run_tools_scripts_before_guest_shutdown" {
  type        = bool
  default     = true
  description = "Enable the execution of pre-shutdown scripts when VMware tools is installed."
}

variable "run_tools_scripts_before_guest_standby" {
  type        = bool
  default     = true
  description = "Enable the execution of pre-standby scripts when VMware tools is installed."
}

# --

variable "hv_mode" {
  type        = string
  default     = "hvAuto"
  description = "The (non-nested) hardware virtualization setting for this virtual machine. Can be one of hvAuto, hvOn, or hvOff."
}

variable "ept_rvi_mode" {
  type        = string
  default     = "automatic"
  description = "The EPT/RVI (hardware memory virtualization) setting for this virtual machine. Can be one of automatic, on, or off."
}

variable "nested_hv_enabled" {
  type        = bool
  default     = false
  description = "Enable nested hardware virtualization on this virtual machine, facilitating nested virtualization in the guest."
}

# --

variable "enable_logging" {
  type        = bool
  default     = false
  description = "Enable logging of virtual machine events to a log file stored in the virtual machine directory."
}

variable "cpu_performance_counters_enabled" {
  type        = bool
  default     = false
  description = "Enable CPU performance counters on this virtual machine."
}

variable "swap_placement_policy" {
  type        = string
  default     = "inherit"
  description = "The swap file placement policy for this virtual machine. Can be one of inherit, hostLocal, or vmDirectory."
}

variable "latency_sensitivity" {
  type        = string
  default     = "normal"
  description = "Controls the scheduling delay of the virtual machine. Use a higher sensitivity for applications that require lower latency, such as VOIP, media player applications, or applications that require frequent access to mouse or keyboard devices. Can be one of low, normal, medium, or high."
}

# --

variable "wait_for_guest_net_timeout" {
  type        = number
  default     = 5
  description = "The amount of time, in minutes, to wait for an available IP address on this virtual machine's NICs. Older versions of VMware Tools do not populate this property. In those cases, this waiter can be disabled and the wait_for_guest_ip_timeout waiter can be used instead. A value less than 1 disables the waiter."
}

variable "wait_for_guest_net_routable" {
  type        = bool
  default     = true
  description = "Controls whether or not the guest network waiter waits for a routable address. When false, the waiter does not wait for a default gateway, nor are IP addresses checked against any discovered default gateways as part of its success criteria. This property is ignored if the wait_for_guest_ip_timeout waiter is used."
}

variable "wait_for_guest_ip_timeout" {
  type        = number
  default     = 0
  description = "The amount of time, in minutes, to wait for an available guest IP address on this virtual machine. This should only be used if your version of VMware Tools does not allow the wait_for_guest_net_timeout waiter to be used. A value less than 1 disables the waiter."
}

variable "ignored_guest_ips" {
  type        = list
  default     = []
  description = "List of IP addresses and CIDR networks to ignore while waiting for an available IP address using either of the waiters. Any IP addresses in this list will be ignored if they show up so that the waiter will continue to wait for a real IP address."
}

# --

variable "shutdown_wait_timeout" {
  type        = number
  default     = 3
  description = "The amount of time, in minutes, to wait for a graceful guest shutdown when making necessary updates to the virtual machine. If force_power_off is set to true, the VM will be force powered-off after this timeout, otherwise an error is returned."
}

variable "migrate_wait_timeout" {
  type        = number
  default     = 10
  description = "The amount of time, in minutes, to wait for a virtual machine migration to complete before failing."
}

variable "force_power_off" {
  type        = bool
  default     = true
  description = "If a guest shutdown failed or timed out while updating or destroying (see shutdown_wait_timeout), force the power-off of the virtual machine."
}

# --

variable "custom_attributes" {
  type        = map
  default     = {}
  description = "Map of custom attribute ids to attribute value strings to set for virtual machine."
}

variable "tags" {
  type        = set(string)
  default     = null
  description = "The IDs of any tags to attach to this resource."
}
