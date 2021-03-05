locals {
  systemd_etcd_data_mount_name = replace(trimprefix(var.data_path, "/"), "/", "-")
  device_partition_name = "${var.device_name}p1"
}

data "ignition_disk" "ectd_data" {
  device = var.device_name

  wipe_table = false

  partition {
    label  = "ETCD-DATA"
    number = 1
    start  = 0
    size   = 0
  }
}

resource "random_uuid" "etcd_data_fs_uuid" {}

data "ignition_filesystem" "ectd_data" {
  name = "etcd-data"

  mount {
    device          = local.device_partition_name
    format          = "ext4"
    wipe_filesystem = false
    label           = "etcd-data"
    uuid            = random_uuid.etcd_data_fs_uuid.result
  }
}

data "ignition_systemd_unit" "etcd_data_mount" {
  name = "${local.systemd_etcd_data_mount_name}.mount"

  content = templatefile("${path.module}/templates/data.mount.tpl", {
    device_name = local.device_partition_name
    data_path   = var.data_path
  })
}
