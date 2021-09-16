data "ignition_file" "etcd_wrapper_sh" {
  path      = "/usr/local/bin/etcd-wrapper.sh"
  mode      = 500
  overwrite = true

  content {
    content = file("${path.module}/scripts/etcd-wrapper.sh")
  }
}

data "ignition_file" "etcd_env" {
  path      = "/etc/etcd/config.env"
  mode      = 420
  overwrite = true

  content {
    content = templatefile("${path.module}/templates/config.env.tpl", {
      cloud_provider        = var.cloud_provider
      user_id               = var.cert_file_owner["uid"]
      cluster_name          = var.name
      pki_path              = var.pki_path
      data_path             = var.data_path
      discovery_service_srv = var.discovery_service_srv
      scheme                = "https"
      client_port           = var.client_port
      peer_port             = var.peer_port
      extra_flags           = local.extra_flags
    })
  }
}

data "ignition_file" "etcd_tgz" {
  path      = "/opt/etcd/etcd-linux-amd64.tar.gz"
  mode      = 500
  overwrite = true

  source {
    source       = local.binaries["etcd"].source
    verification = local.binaries["etcd"].checksum
  }
}

data "ignition_systemd_unit" "etcd_service" {
  name    = "etcd.service"
  enabled = true
  content = templatefile("${path.module}/templates/etcd.service.tpl", {})
}
