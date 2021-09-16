#!/bin/bash
# Wrapper for launching etcd via podman.

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

ETCD_IMAGE_REPO="${ETCD_IMAGE_REPO:-${ETCD_ACI:-quay.io/coreos/etcd}}"
ETCD_IMAGE="${ETCD_IMAGE:-${ETCD_IMAGE_REPO}:${ETCD_IMAGE_TAG}}"

ETCD_BINARY=/usr/local/bin/etcd

if ! test -f ${ETCD_BINARY} ; then
  tar -xvf /opt/etcd/etcd-linux-amd64.tar.gz -C /usr/local/bin --strip-components=1
fi

if [[ $CLOUD_PROVIDER == "aws" ]]; then 
  export HOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/local-hostname | cut -d '.' -f 1)
  export HOST_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
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

PODMAN_RUN_ARGS="${PODMAN_RUN_ARGS} ${PODMAN_OPTS}"

PODMAN="${PODMAN:-/usr/bin/podman}"
set -x
exec ${ETCD_BINARY} \
  --name=${HOSTNAME} \
  --advertise-client-urls=${SCHEME}://${HOST_IP}:${CLIENT_PORT} \
  --initial-advertise-peer-urls=${SCHEME}://${HOST_IP}:${PEER_PORT} \
  --initial-cluster-state=${INITIAL_CLUSTER_STATE} \
  ${ETCD_EXTRA_FLAGS}