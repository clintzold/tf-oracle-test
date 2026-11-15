variable "laptop_cidr" {
  description = "The address my laptop uses inside the IPSec tunnel in CIDR form."
  type        = string

  validation {
    condition     = can(cidrhost(var.laptop_cidr, 0))
    error_message = "laptop_cidr must be a valid CIDR block."
  }
}

variable "laptop_public_ip" {
  description = "The public IPv4 address the IPSec traffic comes from, in this case my routers WAN IP."
  type        = string
}

variable "laptop_ike_identifier" {
  description = "The IKE indentity my laptop represents. Likely behind NAT. This is its private lan ip."
  type        = string
  default     = null
}

variable "ldap_port" {
  description = "TCP/389 where the ldap container will listen."
  type        = number
  default     = 389
}

variable "allow_ssh_from_laptop" {
  description = "Open TCP/22 from the laptop so I can ssh to the vm over the tunnel."
  type        = bool
  default     = true
}

variable "ssh_public_key" {
  description = "SSH public key that will be allowed to log in as 'opc'."
  type        = string
  default     = null
}

variable "instance_shape" {
  description = "Compute shape for the LDAP VM."
  type        = string
  default     = "VM.Standard.E4.Flex"
}

variable "instance_ocpus" {
  description = "OCPUs for Flex shapes (ignored for fixed shapes)."
  type        = number
  default     = 1
}

variable "instance_memory_gbs" {
  description = "Memory in GB for Flex shapes (ignored for fixed shapes)."
  type        = number
  default     = 6
}
