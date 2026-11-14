resource "oci_identity_compartment" "test_compartment" {
  compartment_id = var.tenancy_ocid
  description    = "Temporary sandbox compartment for networking tests"
  name           = "tf-test-sandbox"
  enable_delete  = true
}
