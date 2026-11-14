# Create the Dyanic Routing Gatewar (DRG)
resource "oci_core_drg" "test_drg" {
  compartment_id = oci_identity_compartment.test_compartment.id
  display_name   = "tf-test-drg"
}

# Attach the DRG to your VCN
resource "oci_core_drg_attachment" "test_drg_attachment" {
  drg_id       = oci_core_drg.test_drg.id
  vcn_id       = oci_core_vcn.test_vcn.id
  display_name = "tf-test-drg-attachment"
}
