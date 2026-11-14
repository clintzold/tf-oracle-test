# CPE: OCI's record of the device on the end of the IPSec tunnel
resource "oci_core_cpe" "laptop_cpe" {
  compartment_id = oci_identity_compartment.test_compartment.id
  ip_address     = var.laptop_public_ip
  display_name   = "tf-laptop-cpe"
}

# IPSec connection: creates TWO redundant tunnels on the DRG toward the CPE
resource "oci_core_ipsec" "laptop_ipsec" {
  compartment_id = oci_identity_compartment.test_compartment.id
  cpe_id         = oci_core_cpe.laptop_cpe.id
  drg_id         = oci_core_drg.test_drg.id
  display_name   = "tf-laptop-ipsec"

  # Networks that live on the laptop side. The DRG install these as routes pointing into the tunnel
  static_routes = [var.laptop_cidr]

  # Only set when the laptop is behind NAT (IKE ID != CPE public IP)
  cpe_local_identifier      = var.laptop_ike_identifier
  cpe_local_identifier_type = var.laptop_ike_identifier == null ? null : "IP_ADDRESS"
}

# Read back the two tunnels so I can output their OCI-side public IP's
data "oci_core_ipsec_connection_tunnels" "laptop_tunnels" {
  ipsec_id = oci_core_ipsec.laptop_ipsec.id
}

data "oci_core_ipsec_config" "laptop_ipsec_config" {
  ipsec_id = oci_core_ipsec.laptop_ipsec.id
}

resource "oci_core_ipsec_connection_tunnel_management" "tunnel1" {
  ipsec_id  = oci_core_ipsec.laptop_ipsec.id
  tunnel_id = data.oci_core_ipsec_connection_tunnels.laptop_tunnels.ip_sec_connection_tunnels[0].id
  routing   = "STATIC"

  ike_version             = "V2"
  oracle_can_initiate     = "RESPONDER_ONLY"
  nat_translation_enabled = "AUTO"
}
