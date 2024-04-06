#!/usr/bin/env sh

# Bootstrap the Kubernetes Cluster.

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

# bootstrap the cluster
# - spin-up the KinD cluster
"${SCRIPT_DIR}/cluster/kind/start.sh"
# - apply common configuration
"${SCRIPT_DIR}/cluster/common/start.sh"
# - create troubleshooting pod
"${SCRIPT_DIR}/debug/shell/start.sh"
# - make this repository accessible from inside the cluster
"${SCRIPT_DIR}/workload/git-server/make_repo.sh"
"${SCRIPT_DIR}/workload/git-server/start.sh"
# - deploy ArgoCD and let it deploy everything else using the above Git repository
"${SCRIPT_DIR}/gitops/argo/start.sh"
kubectl rollout status -n "argocd" "deployment/argocd-server"
# - make ArgoCD accessible from the host
"${SCRIPT_DIR}/gitops/argo/port-forward.sh"


# vim: set ts=2 sw=2 tw=0 et :


