data "ignition_file" "etcd_ca" {
  path      = "${var.pki_path}/ca.crt"
  mode      = 420
  uid       = var.cert_file_owner["uid"]
  gid       = var.cert_file_owner["gid"]
  overwrite = true
  

  content {
    content = var.certs["ca_cert"]
  }
}

data "ignition_file" "etcd_client_cert" {
  path      = "${var.pki_path}/client.crt"
  mode      = 256
  uid       = var.cert_file_owner["uid"]
  gid       = var.cert_file_owner["gid"]
  overwrite = true


  content {
    content = var.certs["client_cert"]
  }
}

data "ignition_file" "etcd_client_key" {
  path      = "${var.pki_path}/client.key"
  mode      = 256
  uid       = var.cert_file_owner["uid"]
  gid       = var.cert_file_owner["gid"]
  overwrite = true

  content {
    content = var.certs["client_key"]
  }
}

data "ignition_file" "etcd_server_cert" {
  path      = "${var.pki_path}/server.crt"
  mode      = 256
  uid       = var.cert_file_owner["uid"]
  gid       = var.cert_file_owner["gid"]
  overwrite = true

  content {
    content = var.certs["server_cert"]
  }
}

data "ignition_file" "etcd_server_key" {
  path      = "${var.pki_path}/server.key"
  mode      = 256
  uid       = var.cert_file_owner["uid"]
  gid       = var.cert_file_owner["gid"]
  overwrite = true

  content {
    content = var.certs["server_key"]
  }
}

data "ignition_file" "etcd_peer_cert" {
  path      = "${var.pki_path}/peer.crt"
  mode      = 256
  uid       = var.cert_file_owner["uid"]
  gid       = var.cert_file_owner["gid"]
  overwrite = true

  content {
    content = var.certs["peer_cert"]
  }
}

data "ignition_file" "etcd_peer_key" {
  path      = "${var.pki_path}/peer.key"
  mode      = 256
  uid       = var.cert_file_owner["uid"]
  gid       = var.cert_file_owner["gid"]
  overwrite = true

  content {
    content = var.certs["peer_key"]
  }
}
