# Outputs:
# - Private IP
# - Public IP
# - Private node name
# - Public node name

# iSCSI server

output "iscsisrv_ip" {
  value = google_compute_instance.iscsisrv.network_interface.*.network_ip
}

output "iscsisrv_public_ip" {
  value = google_compute_instance.iscsisrv.network_interface.*.access_config.0.nat_ip
}

output "iscsisrv_name" {
  value = google_compute_instance.iscsisrv.*.name
}

output "iscsisrv_public_name" {
  value = []
}

# Cluster nodes

output "cluster_nodes_ip" {
  value = google_compute_instance.clusternodes.*.network_interface.0.network_ip
}

output "cluster_nodes_public_ip" {
  value = google_compute_instance.clusternodes.*.network_interface.0.access_config.0.nat_ip
}

output "cluster_nodes_name" {
  value = google_compute_instance.clusternodes.*.name
}

output "cluster_nodes_public_name" {
  value = []
}

# Monitoring

output "monitoring_ip" {
  value = join("", google_compute_instance.monitoring.*.network_interface.0.network_ip)
}

output "monitoring_public_ip" {
  value = join("", google_compute_instance.monitoring.*.network_interface.0.access_config.0.nat_ip)
}

output "monitoring_name" {
  value = join("", google_compute_instance.monitoring.*.name)
}

output "monitoring_public_name" {
  value = ""
}

# drbd

output "drbd_ip" {
  value = module.drbd_node.drbd_ip
}

output "drbd_public_ip" {
  value = module.drbd_node.drbd_public_ip
}

output "drbd_name" {
  value = module.drbd_node.drbd_name
}

output "drbd_public_name" {
  value = module.drbd_node.drbd_public_name
}

# netweaver

output "netweaver_ip" {
  value = module.netweaver_node.netweaver_ip
}

output "netweaver_public_ip" {
  value = module.netweaver_node.netweaver_public_ip
}

output "netweaver_name" {
  value = module.netweaver_node.netweaver_name
}

output "netweaver_public_name" {
  value = module.netweaver_node.netweaver_public_name
}
