resource "oci_core_route_table" "private_rt" {
  compartment_id = oci_identity_compartment.test_compartment.id
  vcn_id         = oci_core_vcn.test_vcn.id
  display_name   = "tf-private-rt"

  # Traffic to the laptop goes through the DRG (and then the IPSec tunnel)
  route_rules {
    description       = "Laptop via IPSec / DRG"
    destination       = var.laptop_cidr
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_drg.test_drg.id
  }

  # All other traffic goes out through the NAT gateway
  route_rules {
    description       = "All other traffic via NAT"
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.test_nat_gw.id
  }

  # The DRG must be attached to the VCN before a route can target it
  depends_on = [oci_core_drg_attachment.test_drg_attachment]
}
