locals {
  binaries = merge({
    etcd = {
      source   = "https://storage.googleapis.com/etcd/v3.5.0/etcd-v3.5.0-linux-amd64.tar.gz"
      checksum = "sha512-2df2e0589bb1f9c7fdbddc8405e212b0fd666bb286bbc8a6fdafc69cd2e1a456a5cb6440814a82703f5ec542a952dab0e091cb66baf0b3f21cd2a40cea9ac967"
    }
  }, var.binaries)

  extra_flags = var.extra_flags
}
