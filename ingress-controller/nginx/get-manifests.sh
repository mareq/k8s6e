#!/usr/bin/env sh

# Download Ingress Controller Nginx manifests.

#helm search repo ingress-nginx --versions
INGRESS_NGINX_CHART_VERSION="4.10.0"

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

# generate the manifest from the helm chart
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update ingress-nginx
INGRESS_NGINX_APP_VERSION="$(helm search repo ingress-nginx/ingress-nginx --version="${INGRESS_NGINX_CHART_VERSION}" -o json | jq -r '.[0].app_version')"
echo "ingress-nginx.${INGRESS_NGINX_APP_VERSION}.yaml:"
helm template ingress-nginx ingress-nginx/ingress-nginx --version ${INGRESS_NGINX_CHART_VERSION} > "${MANIFESTS_DIR_BASE}/ingress-nginx.${INGRESS_NGINX_APP_VERSION}.yaml"
ln -sfv "ingress-nginx.${INGRESS_NGINX_APP_VERSION}.yaml" "${MANIFESTS_DIR_BASE}/ingress-nginx.yaml"


# vim: set ts=2 sw=2 tw=0 et :


