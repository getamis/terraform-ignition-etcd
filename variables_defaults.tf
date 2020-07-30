locals {
  containers = merge({
    etcd = {
      repo = "quay.io/coreos/etcd"
      tag  = "v3.4.5"
    }
  }, var.containers)

  extra_flags = merge({
    debug = false
  }, var.extra_flags)
}
