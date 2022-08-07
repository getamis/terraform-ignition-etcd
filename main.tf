data "ignition_file" "etcd_wrapper_sh" {
  overwrite = true
  path      = "/opt/etcd/bin/etcd-wrapper"
  mode      = 500

  content {
    content = file("${path.module}/scripts/etcd-wrapper.sh")
  }
}

data "ignition_file" "etcd_env" {
  overwrite = true

  path = "/etc/etcd/config.env"
  mode = 420

  content {
    content = templatefile("${path.module}/templates/config.env.tpl", {
      image_repo            = local.containers["etcd"].repo
      image_tag             = local.containers["etcd"].tag
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

data "ignition_systemd_unit" "etcd_service" {
  name    = "etcd.service"
  enabled = true
  content = templatefile("${path.module}/templates/etcd.service.tpl", {})
}
