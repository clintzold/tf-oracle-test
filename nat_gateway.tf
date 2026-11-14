resource "oci_core_nat_gateway" "test_nat_gw" {
  compartment_id = oci_identity_compartment.test_compartment.id
  vcn_id         = oci_core_vcn.test_vcn.id
  display_name   = "tf-test-nat-gw"
  block_traffic  = false
}
