data "template_file" "node_exporter" {
  template = file("${path.module}/templates/node-exporter.service.tpl")

  vars = {
    listen_address = "${var.listen_address}:${var.listen_port}"
  }
}

data "ignition_systemd_unit" "node_exporter" {
  name    = "node-exporter.service"
  enabled = true
  content = data.template_file.node_exporter.rendered
}

data "template_file" "node_exporter_fetcher" {
  template = file("${path.module}/templates/node-exporter-fetcher.service.tpl")

  vars = {
    version = var.node_exporter_version
  }
}

data "ignition_systemd_unit" "node_exporter_fetcher" {
  name    = "node-exporter-fetcher.service"
  enabled = true
  content = data.template_file.node_exporter_fetcher.rendered
}
