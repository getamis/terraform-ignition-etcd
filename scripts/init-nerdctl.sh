#!/bin/bash
# Wrapper script for initing nerdctl.

set -eu

NERDCTL_BIN_PATH=${NERDCTL_BIN_PATH:="/opt/bin"}
mkdir -p ${NERDCTL_BIN_PATH}
sudo tar -xvf /opt/bin/nerdctl.tar.gz -C ${NERDCTL_BIN_PATH}