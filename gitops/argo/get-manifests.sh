#!/usr/bin/env sh

# Download ArgoCD manifests.

#helm search repo argo --versions
ARGO_CD_CHART_VERSION="6.7.10"

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

# download the manifest directly
#curl https://raw.githubusercontent.com/argoproj/argo-cd/v${ARGOCD_VERSION}/manifests/install.yaml > "${MANIFESTS_DIR_BASE}/argocd.${ARGOCD_VERSION}.yaml"

# generate the manifest from the helm chart
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update argo
ARGO_CD_APP_VERSION="$(helm search repo argo/argo-cd --version="${ARGO_CD_CHART_VERSION}" -o json | jq -r '.[0].app_version')"
echo "argo-cd.${ARGO_CD_APP_VERSION}.yaml:"
helm template argo/argo-cd --version="${ARGO_CD_CHART_VERSION}" --set-string="fullnameOverride=argocd" > "${MANIFESTS_DIR_ARGO_BASE}/argo-cd.${ARGO_CD_APP_VERSION}.yaml"
ln -sfv "argo-cd.${ARGO_CD_APP_VERSION}.yaml" "${MANIFESTS_DIR_ARGO_BASE}/argo-cd.yaml"


# vim: set ts=2 sw=2 tw=0 et :


