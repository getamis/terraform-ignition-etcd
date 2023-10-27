locals {
  containers = merge({
    etcd = {
      repo = "quay.io/coreos/etcd"
      tag  = "v3.5.9"
    },
    etcd_metrics_proxy = {
      repo = "quay.io/amis/etcd-metrics-proxy"
      tag  = "v0.1.0"
    }
  }, var.containers)

  extra_flags = merge({
    "log-level" = var.log_level
  }, var.extra_flags)

  binaries = merge(
    {
      nerdctl = {
        source   = "https://github.com/containerd/nerdctl/releases/download/v1.6.0/nerdctl-1.6.0-linux-amd64.tar.gz"
        checksum = "sha512-89dcba32badfd1481d88cd5f4179ff99348578af5004a7e96daa05101e99ba7448685596692ada3186f718ffd1166768ac6a22e041c5887e416e6dc7fda97f24"
      }
  }, var.binaries)
}
