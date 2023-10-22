
data "ignition_file" "init_nerdctl" {
  overwrite = true
  path      = "/opt/bin/init-nerdctl"
  mode      = 500

  content {
    content = file("${path.module}/scripts/init-nerdctl.sh")
  }
}

data "ignition_systemd_unit" "init_nerdctl" {
  name    = "init-nerdctl.service"
  enabled = true
  content = templatefile("${path.module}/templates/init-nerdctl.service.tpl", {})
}

data "ignition_file" "nerdctl" {
  path      = "/opt/bin/nerdctl.tar.gz"
  mode      = 500
  overwrite = true

  source {
    source       = local.binaries["nerdctl"].source
    verification = local.binaries["nerdctl"].checksum
  }
}