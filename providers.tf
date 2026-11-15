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
  tenancy_ocid = var.tenancy_ocid
  user_ocid    = var.user_ocid
  fingerprint  = var.fingerprint
  private_key  = var.private_key # change to file("path/to/key.pem") to run Terraform locally (apply will NOT work)
  region       = var.region
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
}

variable "region" {
  description = "OCI Region identifier (e.g, ca-toronto-1, us-ashburn-1)"
  type        = string
}
