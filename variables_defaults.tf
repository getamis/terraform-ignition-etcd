locals {
  containers = merge({
    etcd = {
      repo = "quay.io/coreos/etcd"
      tag  = "v3.5.0"
    }
  }, var.containers)

  extra_flags = merge({
    "log-level" = var.log_level
  }, var.extra_flags)
}
