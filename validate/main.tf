module "etcd_ignition" {
  source = "../"

  name                  = "test"
  discovery_service_srv = "etcd.example.com"

  certs = {
    ca_cert     = "0UJHPe+UtjQAed6LhHLGcX1+QrISIX/5Bt/zRcCETwg="
    client_key  = "A7jTKa8UKXmUSgXLNLATeBSkYzZqOxyjawjrwLpMXqE="
    client_cert = "QikibYHU4m80WNnd3VMCKvnyzpVFDldExD5p1TR917I="
    server_key  = "6eU3CZWKjAysCXPpObwj/9+2jJTFI8jb8ugt0rgSye4="
    server_cert = "YhlVt1Tf90pUfOTfWHgoIvANgpAE2aEtm70+Va8WNdA="
    peer_key    = "nYHOqLLpFqL4w4QgbFSjSFD/2G6pr77muNV0UJkxbdE="
    peer_cert   = "lgi2FchJ6Oh3OR6POh4A7paFwj4vEy5tvxJwgq6PVXs="
  }
}

data "ignition_config" "main" {
  files       = module.etcd_ignition.files
  systemd     = module.etcd_ignition.systemd_units
  filesystems = module.etcd_ignition.filesystems
  disks       = module.etcd_ignition.disks
}

resource "local_file" "file" {
  content  = data.ignition_config.main.rendered
  filename = "${path.root}/output/etcd.ign"
}
