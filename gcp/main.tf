module "drbd_node" {
  source                 = "./modules/drbd_node"
  drbd_count             = var.drbd_enabled == true ? 2 : 0
  machine_type           = var.drbd_machine_type
  compute_zones          = data.google_compute_zones.available.names
  network_name           = google_compute_network.ha_network.name
  network_subnet_name    = google_compute_subnetwork.ha_subnet.name
  drbd_image             = var.drbd_image
  drbd_data_disk_size    = var.drbd_data_disk_size
  drbd_data_disk_type    = var.drbd_data_disk_type
  drbd_cluster_vip       = var.drbd_cluster_vip
  gcp_credentials_file   = var.gcp_credentials_file
  network_domain         = "tf.local"
  host_ips               = var.drbd_ips
  iscsi_srv_ip           = google_compute_instance.iscsisrv.network_interface.0.network_ip
  public_key_location    = var.public_key_location
  private_key_location   = var.private_key_location
  cluster_ssh_pub        = var.cluster_ssh_pub
  cluster_ssh_key        = var.cluster_ssh_key
  reg_code               = var.reg_code
  reg_email              = var.reg_email
  reg_additional_modules = var.reg_additional_modules
  ha_sap_deployment_repo = var.ha_sap_deployment_repo
  monitoring_enabled     = var.monitoring_enabled
  devel_mode             = var.devel_mode
  provisioner            = var.provisioner
  background             = var.background
}

module "netweaver_node" {
  source                    = "./modules/netweaver_node"
  netweaver_count           = var.netweaver_enabled == true ? 4 : 0
  machine_type              = var.netweaver_machine_type
  compute_zones             = data.google_compute_zones.available.names
  network_name              = google_compute_network.ha_network.name
  network_subnet_name       = google_compute_subnetwork.ha_subnet.name
  netweaver_image           = var.netweaver_image
  gcp_credentials_file      = var.gcp_credentials_file
  network_domain            = "tf.local"
  host_ips                  = var.netweaver_ips
  iscsi_srv_ip              = google_compute_instance.iscsisrv.network_interface.0.network_ip
  public_key_location       = var.public_key_location
  private_key_location      = var.private_key_location
  cluster_ssh_pub           = var.cluster_ssh_pub
  cluster_ssh_key           = var.cluster_ssh_key
  netweaver_software_bucket = var.netweaver_software_bucket
  netweaver_nfs_share       = "${var.drbd_cluster_vip}:/HA1"
  hana_cluster_vip          = var.hana_cluster_vip
  virtual_host_ips          = var.netweaver_virtual_ips
  reg_code                  = var.reg_code
  reg_email                 = var.reg_email
  reg_additional_modules    = var.reg_additional_modules
  ha_sap_deployment_repo    = var.ha_sap_deployment_repo
  devel_mode                = var.devel_mode
  provisioner               = var.provisioner
  background                = var.background
  monitoring_enabled        = var.monitoring_enabled
}
