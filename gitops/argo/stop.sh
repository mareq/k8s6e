#!/usr/bin/env sh

# Stop ArgoCD.

OVERLAY_NAME="${OVERLAY_NAME:-kind}"

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

MANIFESTS_DIR_ARGO="${MANIFESTS_DIR}/argo"
MANIFESTS_DIR_ARGO_OVERLAYS="${MANIFESTS_DIR_ARGO}/overlays"

MANIFESTS_DIR_APPOFAPPS="${MANIFESTS_DIR}/app-of-apps"
MANIFESTS_DIR_APP_OF_APPS_OVERLAYS="${MANIFESTS_DIR_APPOFAPPS}/overlays"

# these are deployed by the app-of-apps
#MANIFESTS_DIR_APPS="${MANIFESTS_DIR}/apps"
#MANIFESTS_DIR_APPS_OVERLAYS="${MANIFEST_DIR_APPS}/overlays"

# deploy
kustomize build "${MANIFESTS_DIR_ARGO_OVERLAYS}/${OVERLAY_NAME}" | kubectl apply -f -
kustomize build "${MANIFESTS_DIR_APP_OF_APPS_OVERLAYS}/${OVERLAY_NAME}" | kubectl apply -f -
#kustomize build "${MANIFESTS_DIR_APPS_OVERLAYS}/${OVERLAY_NAME}" | kubectl apply -f -


# vim: set ts=2 sw=2 tw=0 et :


