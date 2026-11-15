terraform {
  required_version = "~> 1.17.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 9.13"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key      = var.private_key
  private_key_path = var.private_key_path # Optionally define in local tfvars file to run terraform cmds
  region           = var.region
}

variable "tenancy_ocid" {
  description = "Your Tenancy OCID"
  type        = string
}

variable "user_ocid" {
  description = "Your User OCID"
  type        = string
}

variable "fingerprint" {
  description = "Your Key Fingerprint"
  type        = string
}

variable "private_key" {
  description = "Private key for GitHub runners"
  type        = string
  sensitive   = true
  default     = null
}

variable "private_key_path" {
  description = "Optional private key path for local dev purposes."
  type        = string
  default     = null
}

variable "region" {
  description = "OCI Region identifier (e.g, ca-toronto-1, us-ashburn-1)"
  type        = string
}
