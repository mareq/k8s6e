#!/usr/bin/env sh

# Start the KinD cluster.

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
CONFIG_BASE_DIR="${CONFIG_DIR}/base"
CONFIG_ACTUAL_DIR="${CONFIG_DIR}/actual"

# cluster configuration
KIND_CONFIG_FILE="cluster.yaml"
KIND_CONFIG_BASE_PATH="${CONFIG_BASE_DIR}/${KIND_CONFIG_FILE}"
KIND_CONFIG_ACTUAL_PATH="${CONFIG_ACTUAL_DIR}/${KIND_CONFIG_FILE}"
KIND_HOSTFS_ROOT_PATH="./../../"
KIND_HOSTFS_MOUNT_JSON=$(
cat <<EOF
{
  "hostPath": "${KIND_HOSTFS_ROOT_PATH}",
  "containerPath": "/mnt/hostfs"
}
EOF
)
cat "${KIND_CONFIG_BASE_PATH}" | yq -o json | jq ".nodes[].extraMounts += [${KIND_HOSTFS_MOUNT_JSON}]" | yq -p json > "${KIND_CONFIG_ACTUAL_PATH}"
KIND_CLUSTER_NAME="$(cat "${KIND_CONFIG_ACTUAL_PATH}" | yq -r .name)"

# start the KinD cluster
# the directory has to be changed so that $KIND_HOSTFS_ROOT_PATH has the correct context
# (we want it to be relative path, so that we do not push host-specific paths into Git)
ORIGINAL_WORKING_DIRECTORY="$(pwd)"
cd "${SCRIPT_DIR}"
kind create cluster --wait 5m --config="${KIND_CONFIG_ACTUAL_PATH}"
cd "${ORIGINAL_WORKING_DIRECTORY}"

# limit the memory usage of the KinD cluster
docker ps --filter="label=io.x-k8s.kind.cluster=${KIND_CLUSTER_NAME}" --filter="label=io.x-k8s.kind.role=control-plane" -q | xargs docker update --memory="4.0g" --memory-swap="4.0g"
docker ps --filter="label=io.x-k8s.kind.cluster=${KIND_CLUSTER_NAME}" --filter="label=io.x-k8s.kind.role=worker" -q | xargs docker update --memory="4.0g" --memory-swap="4.0g"

# set kubernetes context
kubectl config use-context "kind-${KIND_CLUSTER_NAME}"
CURRENT_CONTEXT="$(kubectl config current-context)"
if [ "x${CURRENT_CONTEXT}" != "xkind-${KIND_CLUSTER_NAME}" ]; then
  echo "ERROR: kubectl context is not set to \`kind-${KIND_CLUSTER_NAME}\`"
  exit 1
fi


# vim: set ts=2 sw=2 tw=0 et :


