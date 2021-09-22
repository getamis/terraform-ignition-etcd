variable "name" {
  description = "Human-readable name for this member."
  type        = string
}

variable "containers" {
  description = "Desired containers(etcd) repo and tag."
  type = map(object({
    repo = string
    tag  = string
  }))
  default = {}
}

variable "cloud_provider" {
  description = "The name of public cloud."
  type        = string
  default     = "aws"
}

variable "certs" {
  description = "The etcd certificates."
  type        = map(string)
  default     = {}
}

variable "pki_path" {
  description = "The etcd certificates path"
  type        = string
  default     = "/etc/ssl/etcd"
}

variable "cert_file_owner" {
  type = object({
    uid = number
    gid = number
  })

  default = {
    uid = 232
    gid = 232
  }
}

variable "discovery_service_srv" {
  description = "DNS srv domain used to bootstrap the cluster."
  type        = string
}

variable "client_port" {
  description = "etcd client communication port."
  default     = 2379
}

variable "peer_port" {
  description = "etcd server to server port."
  default     = 2380
}

variable "data_path" {
  description = "The path for data store."
  type        = string
  default     = "/var/lib/etcd"
}

variable "device_name" {
  description = "Which block device will attach to data path."
  type        = string
  default     = "/dev/nvme1n1"
}

variable "log_level" {
  description = "etcd log level, supports debug, info, warn, error, panic, or fatal"
  type        = string
  default     = "info"
}

variable "extra_flags" {
  description = "The extra flags of etcd. The variables need to follow https://etcd.io/docs/v3.4.0/op-guide/configuration/. Do not use underline."
  default     = {}
}