#!/usr/bin/env sh

# Download MetalLB manifests.

METALLB_VERSION="0.14.3"

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
MANIFESTS_DIR="${SCRIPT_DIR}/manifests"
MANIFESTS_DIR_BASE="${MANIFESTS_DIR}/base"

echo "metallb-native.yaml"
curl https://raw.githubusercontent.com/metallb/metallb/v${METALLB_VERSION}/config/manifests/metallb-native.yaml > "${MANIFESTS_DIR_BASE}/metallb-native.${METALLB_VERSION}.yaml"
ln -sfv "metallb-native.${METALLB_VERSION}.yaml" "${MANIFESTS_DIR_BASE}/metallb-native.yaml"

echo "metallb-config.yaml"
curl https://kind.sigs.k8s.io/examples/loadbalancer/metallb-config.yaml > "${MANIFESTS_DIR_BASE}/metallb-config.${METALLB_VERSION}.yaml"
ln -sfv "metallb-config.${METALLB_VERSION}.yaml" "${MANIFESTS_DIR_BASE}/metallb-config.yaml"


# vim: set ts=2 sw=2 tw=0 et :


