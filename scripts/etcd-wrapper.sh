#!/bin/bash
# Wrapper for launching etcd via nerdctl.

set -e

function require_ev_all() {
	for rev in $@ ; do
		if [[ -z "${!rev}" ]]; then
			echo "${rev}" is not set
			exit 1
		fi
	done
}

function require_ev_one() {
	for rev in $@ ; do
		if [[ ! -z "${!rev}" ]]; then
			return
		fi
	done
	echo One of $@ must be set
	exit 1
}

require_ev_one ETCD_IMAGE ETCD_IMAGE_TAG

ETCD_IMAGE_REPO="${ETCD_IMAGE_REPO:-${ETCD_ACI:-quay.io/coreos/etcd}}"
ETCD_IMAGE="${ETCD_IMAGE:-${ETCD_IMAGE_REPO}:${ETCD_IMAGE_TAG}}"

# Waiting for ENI (eth1) to be attached to the instance
set +e
until [[ $(ifconfig eth1 2>/dev/null) ]]; do
  echo "Waiting for ENI (eth1) to be attached..."
  sleep 10
done
set -e

if [[ $CLOUD_PROVIDER == "aws" ]]; then 
  MAC_ADDR=$(ifconfig eth1 | grep ether | awk '{print $2}')
  export HOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${MAC_ADDR}/local-hostname | cut -d '.' -f 1)
  export HOST_IP=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${MAC_ADDR}/local-ipv4s)
fi

[[ ! -n "$HOSTNAME" ]] && export HOSTNAME=$(hostname)
[[ ! -n "$HOST_IP" ]] && export HOST_IP=$(ip -o route get 8.8.8.8 | sed -e 's/^.* src \([^ ]*\) .*$/\1/')

if [ -d "${ETCD_DATA_DIR}" ]; then
  CLUSTER_STATE_CHECK="${ETCD_DATA_DIR}/${HOST_IP}.state"
  if [ -f "$CLUSTER_STATE_CHECK" ]; then
    INITIAL_CLUSTER_STATE=existing
  else
    INITIAL_CLUSTER_STATE=new
    chown "${USER_ID}:${USER_ID}" "${ETCD_DATA_DIR}"
    touch ${CLUSTER_STATE_CHECK}
  fi
else
  echo "ERROR: Failed to find the '${ETCD_DATA_DIR}'.  Please recheck the mount point." 1>&2
  exit 1
fi

DOCKER_RUN_ARGS="${DOCKER_RUN_ARGS} ${DOCKER_OPTS}"

NERDCTL="${NERDCTL:-/opt/bin/nerdctl}"
set -x
exec ${NERDCTL} run \
  -v ${ETCD_DATA_DIR}:${ETCD_DATA_DIR}:rw \
  -v /etc/ssl/certs:/etc/ssl/certs:ro \
  -v ${ETCD_CERT_PATH}:${ETCD_CERT_PATH}:rw \
  -v /usr/share/ca-certificates:/usr/share/ca-certificates:ro \
  -v /etc/hosts:/etc/hosts:ro \
  --env-file=/etc/etcd/config.env \
  --net=host \
  --pid=host \
  --user=${USER_ID} \
  --name=etcd \
  ${DOCKER_RUN_ARGS} \
  ${ETCD_IMAGE} \
    etcd \
      --name=${HOSTNAME} \
      --advertise-client-urls=${SCHEME}://${HOST_IP}:${CLIENT_PORT} \
      --initial-advertise-peer-urls=${SCHEME}://${HOST_IP}:${PEER_PORT} \
      --initial-cluster-state=${INITIAL_CLUSTER_STATE} \
      ${ETCD_EXTRA_FLAGS}