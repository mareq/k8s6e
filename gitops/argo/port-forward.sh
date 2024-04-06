#!/usr/bin/env sh

# Port-forward for the ArgoCD server (web UI).

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
MANIFESTS_DIR_ARGO_BASE="${MANIFESTS_DIR_ARGO}/base"

NS_FILE="namespace.yaml"
ACTUAL_NS_PATH="${MANIFESTS_DIR_ARGO_BASE}/${NS_FILE}"
NAMESPACE="$(cat "${ACTUAL_NS_PATH}" | yq -o json | jq -r '.metadata.name')"

PASSWORD="$(kubectl get secret -n "${NAMESPACE}" argocd-initial-admin-secret -o json | jq -r '.data.password' | base64 --decode)"
echo "username: admin"
echo "initial password: ${PASSWORD}"
kubectl port-forward -n "${NAMESPACE}" svc/argocd-server 1875:443


# vim: set ts=2 sw=2 tw=0 et :


