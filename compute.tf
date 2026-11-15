# Availability domans are listed at the tenancy level
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Newest Oracle Linux 9 platform image that is compatible with the chosen shape
data "oci_core_images" "ol9" {
  compartment_id           = oci_identity_compartment.test_compartment.id
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = var.instance_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "vm" {
  compartment_id      = oci_identity_compartment.test_compartment.id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  display_name        = "tf-ldap-vm"
  shape               = var.instance_shape

  # Only Flex shapes accept shape_config; skip it for fixed shapes like E2.1.Micro
  dynamic "shape_config" {
    for_each = endswith(var.instance_shape, ".Flex") ? [1] : []
    content {
      ocpus         = var.instance_ocpus
      memory_in_gbs = var.instance_memory_gbs
    }
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ol9.images[0].id
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.private_subnet.id
    assign_public_ip = false
    hostname_label   = "ldap"
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(templatefile("${path.module}/scripts/install-docker.sh.tftpl", {
      ldap_port = var.ldap_port
    }))
  }

  # Don't rebuild the VM every time Oracle publishes a newer image
  lifecycle {
    ignore_changes = [source_details[0].source_id]
  }
}
