terraform {
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
  private_key_path = var.private_key_path
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

variable "private_key_path" {
  description = "Local path to your private PEM key"
  type        = string
}

variable "region" {
  description = "OCI Region identifier (e.g, ca-toronto-1, us-ashburn-1)"
  type        = string
}
