locals {
  containers = merge({
    etcd = {
      repo = "quay.io/coreos/etcd"
      tag  = "v3.5.0"
    }
  }, var.containers)

  extra_flags = var.extra_flags
}
