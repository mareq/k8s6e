#!/usr/bin/env sh

# Stop Debugging Container.

OVERLAY_NAME="${OVERLAY_NAME:-default}"

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
MANIFESTS_OVERLAYS_DIR="${MANIFESTS_DIR}/overlays"

# "undeploy"
kustomize build "${MANIFESTS_OVERLAYS_DIR}/${OVERLAY_NAME}" | kubectl delete -f -


# vim: set ts=2 sw=2 tw=0 et :


