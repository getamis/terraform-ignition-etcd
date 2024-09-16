locals {
  containers = merge({
    etcd = {
      repo = "quay.io/coreos/etcd"
      tag  = "v3.5.15"
    },
    etcd_metrics_proxy = {
      repo = "quay.io/amis/etcd-metrics-proxy"
      tag  = "v0.1.0"
    }
  }, var.containers)

  extra_flags = merge({
    "log-level" = var.log_level
  }, var.extra_flags)
}
