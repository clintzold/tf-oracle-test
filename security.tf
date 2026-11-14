resource "oci_core_security_list" "private_sl" {
  compartment_id = oci_identity_compartment.test_compartment.id
  vcn_id         = oci_core_vcn.test_vcn.id
  display_name   = "tf-private-sl"

  # Egress: VM may initiate anything outbound
  egress_security_rules {
    description = "Allow all outboud."
    destination = "0.0.0.0/0"
    protocol    = "all"
    stateless   = false
  }

  # Ingress: VM receives LDAP from laptop ONLY
  ingress_security_rules {
    description = "Allow LDAP(TCP/389) inbound from laptop only."
    source      = var.laptop_cidr
    protocol    = "6" # TCP
    stateless   = false

    tcp_options {
      min = var.ldap_port
      max = var.ldap_port
    }

  }

  # Ingress: SSH from laptop
  dynamic "ingress_security_rules" {
    for_each = var.allow_ssh_from_laptop ? [1] : []
    content {
      description = "SSH from laptop over IPSec"
      source      = var.laptop_cidr
      protocol    = "6"
      stateless   = false

      tcp_options {
        min = 22
        max = 22
      }
    }
  }

  # Ingress: ping from laptop to test tunnel is working
  ingress_security_rules {
    description = "ICMP echo from laptop"
    source      = var.laptop_cidr
    protocol    = "1" # ICMP
    stateless   = false

    icmp_options {
      type = 8 # echo request
    }
  }

  # Ingress: Path-MTU discovery. IPSec add overhead, so this matters.
  ingress_security_rules {
    description = "ICMP fragmentation-needed (PMTUD)"
    source      = "0.0.0.0/0"
    protocol    = "1"
    stateless   = false

    icmp_options {
      type = 3
      code = 4
    }
  }

  # Ingress: anything from inside the VCN (VM to VM, future services)
  ingress_security_rules {
    description = "All traffic from within the VCN"
    source      = oci_core_vcn.test_vcn.cidr_blocks[0]
    protocol    = "all"
    stateless   = false
  }
}
