#!/usr/bin/env sh

# Stop the KinD cluster.

# script directory
get_script_dir () {
  SCRIPT_FILE="${0}"
  # while ${SCRIPT_FILE} is a symlink, resolve it
  while [ -h "${SCRIPT_FILE}" ]; do
    SCRIPT_DIR="$(cd -P "$(dirname "${SCRIPT_FILE}")" && pwd)"
    SCRIPT_FILE="$(readlink "${SCRIPT_FILE}")"
    # if ${SCRIPT_FILE} was a relative symlink
    # (so no `/` as prefix, need to resolve it relative to the symlink base directory)
    [[ "${SCRIPT_FILE}" =~ ^/.* ]] || SCRIPT_FILE="${SCRIPT_DIR}/${SCRIPT_FILE}"
  done
  SCRIPT_DIR="$( cd -P "$( dirname "${SCRIPT_FILE}" )" && pwd )"
  echo "${SCRIPT_DIR}"
}
SCRIPT_DIR="$(get_script_dir)"
CONFIG_DIR="${SCRIPT_DIR}/config"
CONFIG_ACTUAL_DIR="${CONFIG_DIR}/actual"

# cluster configuration
KIND_BASE_CONFIG_FILE="cluster.yaml"
KIND_ACTUAL_CONFIG_PATH="${CONFIG_ACTUAL_DIR}/${KIND_BASE_CONFIG_FILE}"

# delete the KinD cluster
KIND_CLUSTER_NAME="$(yq -r .name "${KIND_ACTUAL_CONFIG_PATH}")"
kind delete cluster --name="${KIND_CLUSTER_NAME}"


# vim: set ts=2 sw=2 tw=0 et :


