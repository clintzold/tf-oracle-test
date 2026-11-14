# Create the virtual cloud network (VCN)
resource "oci_core_vcn" "test_vcn" {
  compartment_id = oci_identity_compartment.test_compartment.id
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "tf-test-vcn"
  dns_label      = "tftestvcn"
}

# Create an isolated private subnet (no public ips allowed)
resource "oci_core_subnet" "private_subnet" {
  compartment_id             = oci_identity_compartment.test_compartment.id
  vcn_id                     = oci_core_vcn.test_vcn.id
  cidr_block                 = "10.0.1.0/24"
  display_name               = "tf-private-subnet"
  dns_label                  = "private"
  prohibit_public_ip_on_vnic = true

  route_table_id    = oci_core_route_table.private_rt.id
  security_list_ids = [oci_core_security_list.private_sl.id]
}
