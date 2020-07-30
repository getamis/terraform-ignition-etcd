[![GitHub license](https://img.shields.io/github/license/getamis/terraform-etcd-ignition)](https://github.com/getamis/terraform-etcd-ignition/blob/master/LICENSE)
# Terraform etcd Ignition module
A terraform Ignition module to bootstrap an etcd cluster with CoreOS Container Linux/Flatcar Container Linux/Fedora CoreOS. (Experiment)

## Requirements

* Terraform v0.12.0+.
* [terraform-provider-ignition](https://github.com/terraform-providers/terraform-provider-ignition) 1.2.1+.

## Usage example
The following block is show you how to use this module for bootstrapping a cluster:
 
```hcl
module "ignition_etcd" {
  source = "git::ssh://git@github.com/getamis/terraform-etcd-ignition"

  name                  = "test"
  discovery_service_srv = "etcd.example.com"

  // Create certs through https://registry.terraform.io/providers/hashicorp/tls/latest/docs.
  certs = {
    ca_cert     = module.etcd_ca.cert_pem
    client_key  = module.etcd_client_cert.private_key_pem
    client_cert = module.etcd_client_cert.cert_pem
    server_key  = module.etcd_server_cert.private_key_pem
    server_cert = module.etcd_server_cert.cert_pem
    peer_key    = module.etcd_peer_cert.private_key_pem
    peer_cert   = module.etcd_peer_cert.cert_pem
  }
}
```

> See [docs/variables.md](docs/variables.md) for the detail variable inputs and outputs.

## Contributing
There are several ways to contribute to this project:

1. **Find bug**: create an issue in our Github issue tracker.
2. **Fix a bug**: check our issue tracker, leave comments and send a pull request to us to fix a bug.
3. **Make new feature**: leave your idea in the issue tracker and discuss with us then send a pull request!

## License
This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.
