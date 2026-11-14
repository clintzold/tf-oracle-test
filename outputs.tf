output "subnet_cidr" {
  description = "Put this in the laptop's IPSec config as the remote subnet (rightsubnet)"
  value       = oci_core_subnet.private_subnet.cidr_block
}

output "ipsec_tunnel_public_ips" {
  description = "OCI-side public IPs of the two tunnels. Use tunnel 1 as 'right' on the laptop."
  value       = [for t in data.oci_core_ipsec_connection_tunnels.laptop_tunnels.ip_sec_connection_tunnels : t.vpn_ip]
}

output "ipsec_tunnel_psks" {
  description = "Pre-shared keys for each tunnel. View with: 'terraform output -json ipsec_tunnel_psks'"
  value       = [for t in data.oci_core_ipsec_config.laptop_ipsec_config.tunnels : t.shared_secret]
  sensitive   = true
}

output "ldap_vm_private_ip" {
  description = "SSH / LDAP target from the laptop once the tunnel is up."
  value       = oci_core_instance.vm.private_ip
}

output "ipsec_tunnel1_ip" {
  description = "OCI public IP of the IKEv2 tunnel. Use as remote_addrs / remote id in swanctl."
  value       = oci_core_ipsec_connection_tunnel_management.tunnel1.vpn_ip
}
