output "systemd_units" {
  value = concat([
    data.ignition_systemd_unit.etcd_service.rendered,
    data.ignition_systemd_unit.etcd_data_mount.rendered,
    data.ignition_systemd_unit.init_nerdctl.rendered,
    ],
    var.enable_metrics_proxy ? [
      data.ignition_systemd_unit.etcd_metrics_proxy_service.rendered
    ] : []
  )
}

output "files" {
  value = concat([
    data.ignition_file.etcd_env.rendered,
    data.ignition_file.etcd_wrapper_sh.rendered,
    data.ignition_file.etcd_ca.rendered,
    data.ignition_file.etcd_client_cert.rendered,
    data.ignition_file.etcd_client_key.rendered,
    data.ignition_file.etcd_server_cert.rendered,
    data.ignition_file.etcd_server_key.rendered,
    data.ignition_file.etcd_peer_cert.rendered,
    data.ignition_file.etcd_peer_key.rendered,
    data.ignition_file.init_nerdctl.rendered,
    data.ignition_file.nerdctl.rendered,
    ],
    var.enable_metrics_proxy ? [
      data.ignition_file.etcd_metrics_proxy_wrapper_sh.rendered
  ] : [])
}

output "filesystems" {
  value = [
    data.ignition_filesystem.ectd_data.rendered
  ]
}

output "disks" {
  value = [
    data.ignition_disk.ectd_data.rendered
  ]
}