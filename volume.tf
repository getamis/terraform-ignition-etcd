data "ignition_filesystem" "ectd_data" {
  name = "etcd-data"

  mount {
    device = var.device_name
    format = "ext4"
  }
}

data "ignition_disk" "ectd_data" {
  device = var.device_name

  partition {
    number = 1
    start  = 0
    size   = 0
  }
}

locals {
  systemd_etcd_data_mount_name = replace(trimprefix(var.data_path, "/"), "/", "-")
}

data "ignition_systemd_unit" "etcd_data_mount" {
  name = "${local.systemd_etcd_data_mount_name}.mount"

  content = templatefile("${path.module}/templates/data.mount.tpl", {
    device_name = var.device_name
    data_path   = var.data_path
  })
}
