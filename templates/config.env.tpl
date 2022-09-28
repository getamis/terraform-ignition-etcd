# ETCD SELF DEFINE CONFIGURATION
ETCD_IMAGE_REPO=${image_repo}
ETCD_IMAGE_TAG=${image_tag}
CLIENT_PORT=${client_port}
PEER_PORT=${peer_port}
SCHEME=${scheme}
USER_ID=${user_id}
CLOUD_PROVIDER=${cloud_provider}

# ETCD METRICS PROXY CONFIGURATION
ETCD_METRICS_PROXY_IMAGE_REPO=${proxy_image_repo}
ETCD_METRICS_PROXY_IMAGE_TAG=${proxy_image_tag}
ETCD_METRICS_PROXY_PORT=${proxy_port}


# ETCD OFFICIAL CONFIGURATION
ETCD_CERT_PATH=${pki_path}
ETCD_CERT_FILE=${pki_path}/server.crt
ETCD_KEY_FILE=${pki_path}/server.key
ETCD_PEER_CERT_FILE=${pki_path}/peer.crt
ETCD_PEER_KEY_FILE=${pki_path}/peer.key
ETCD_PEER_TRUSTED_CA_FILE=${pki_path}/ca.crt
ETCD_TRUSTED_CA_FILE=${pki_path}/ca.crt
ETCD_PEER_CLIENT_CERT_AUTH=true
ETCD_CLIENT_CERT_AUTH=true
ETCD_LISTEN_CLIENT_URLS=${scheme}://0.0.0.0:${client_port}
ETCD_LISTEN_PEER_URLS=${scheme}://0.0.0.0:${peer_port}
ETCD_DATA_DIR=${data_path}
ETCD_DISCOVERY_SRV=${discovery_service_srv}
ETCD_INITIAL_CLUSTER_TOKEN=${cluster_name}
ETCD_LOGGER=zap
ETCD_EXTRA_FLAGS="%{ for flag, value in extra_flags ~}%{ if value != "" ~} --${flag}=${value} %{ endif ~}%{ endfor ~}"