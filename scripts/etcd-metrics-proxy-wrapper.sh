#!/bin/bash
# Wrapper for launching etcd-metrics-proxy via docker.

set -e

function require_ev_all() {
	for rev in $@ ; do
		if [[ -z "${!rev}" ]]; then
			echo "${rev}" is not set
			exit 1
		fi
	done
}

ETCD_METRICS_PROXY_IMAGE=${ETCD_METRICS_PROXY_IMAGE_REPO}:${ETCD_METRICS_PROXY_IMAGE_TAG}

# Waiting for ENI (eth1) to be attached to the instance
set +e
until [[ $(ifconfig eth1 2>/dev/null) ]]; do
  echo "Waiting for ENI (eth1) to be attached..."
  sleep 10
done
set -e

if [[ $CLOUD_PROVIDER == "aws" ]]; then 
  export HOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/local-hostname)
  export HOST_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
fi

[[ ! -n "$HOSTNAME" ]] && export HOSTNAME=$(hostname)
[[ ! -n "$HOST_IP" ]] && export HOST_IP=$(ip -o route get 8.8.8.8 | sed -e 's/^.* src \([^ ]*\) .*$/\1/')

DOCKER_RUN_ARGS="${DOCKER_RUN_ARGS} ${DOCKER_OPTS}"

NERDCTL="${NERDCTL:-/opt/bin/nerdctl}"
set -x
exec ${NERDCTL} run \
  -v ${ETCD_CERT_PATH}:${ETCD_CERT_PATH}:ro \
  --env-file=/etc/etcd/config.env \
  --net=host \
  --pid=host \
  --user=${USER_ID} \
  --name=etcd-metrics-proxy \
  ${DOCKER_RUN_ARGS} \
  ${ETCD_METRICS_PROXY_IMAGE} \
    -etcd-ca="${ETCD_TRUSTED_CA_FILE}" \
    -etcd-cert="${ETCD_CERT_FILE}" \
    -etcd-key="${ETCD_KEY_FILE}" \
    -port="${ETCD_METRICS_PROXY_PORT}" \
    -upstream-host="${HOST_IP}" \
    -upstream-port="${CLIENT_PORT}" \
    -upstream-server-name="${HOSTNAME}"