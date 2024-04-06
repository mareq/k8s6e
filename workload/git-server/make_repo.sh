#!/usr/bin/env sh

# Create the Git repository to be served by the Git server.

GIT_REPO_NAME="${GIT_REPO_NAME:-k8s6r}"
GIT_REMOTE_NAME="${GIT_REMOTE_NAME:-local}"
GIT_REFS_TO_PUSH="${GIT_REFS_TO_PUSH:-master}" # space-separated list

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
REPOSITORIES_DIR="${SCRIPT_DIR}/repositories"

GIT_ROOT_PATH="$(git rev-parse --show-toplevel)"
GIT_REMOTE_PATH="$(realpath -s --relative-to="${GIT_ROOT_PATH}" "${REPOSITORIES_DIR}")/${GIT_REPO_NAME}.git"

# make sure there is bare repository at ${GIT_REMOTE_PATH}
if [ -d "${GIT_ROOT_PATH}/${GIT_REMOTE_PATH}" ]; then
  GIT_IS_BARE="$(git --git-dir="${GIT_ROOT_PATH}/${GIT_REMOTE_PATH}" rev-parse --is-bare-repository)"
  STATUS="${?}"
  if [ "x${STATUS}" != "x0" ] || [ "x${GIT_IS_BARE}" != "xtrue" ]; then
    echo "ERROR: The repository at ${GIT_REMOTE_PATH} must be a bare repository referenced by the remote ${GIT_REMOTE_NAME}"
    exit 1
  fi
else
  mkdir -p "${GIT_ROOT_PATH}/${GIT_REMOTE_PATH}"
  git --git-dir="${GIT_ROOT_PATH}/${GIT_REMOTE_PATH}" init --bare
  STATUS="${?}"
  if [ "x${STATUS}" != "x0" ]; then
    echo "ERROR: Failed to create a bare repository at ${GIT_REMOTE_PATH}"
    exit 1
  fi
  git --git-dir="${GIT_ROOT_PATH}/${GIT_REMOTE_PATH}" --bare update-server-info
  mv "${GIT_ROOT_PATH}/${GIT_REMOTE_PATH}/hooks/post-update.sample" "${GIT_ROOT_PATH}/${GIT_REMOTE_PATH}/hooks/post-update"
  chmod a+x "${GIT_ROOT_PATH}/${GIT_REMOTE_PATH}/hooks/post-update"
fi
# make sure there is a remote with the name ${GIT_REMOTE_NAME} pointing to ${GIT_REMOTE_PATH}
GIT_REMOTE_PATH_ACTUAL="$(git remote get-url ${GIT_REMOTE_NAME})"
STATUS="${?}"
if [ "x${STATUS}" != "x0" ]; then
  echo "Remote ${GIT_REMOTE_NAME} does not exist: Adding ${GIT_REMOTE_NAME} with path ${GIT_REMOTE_PATH}"
  git remote add "${GIT_REMOTE_NAME}" "${GIT_REMOTE_PATH}"
  STATUS="${?}"
  if [ "x${STATUS}" != "x0" ]; then
    echo "ERROR: Failed to add remote ${GIT_REMOTE_NAME} with path ${GIT_REMOTE_PATH}"
    exit 1
  fi
elif [ "x${GIT_REMOTE_PATH}" != "x${GIT_REMOTE_PATH_ACTUAL}" ]; then
  echo "Remote \`${GIT_REMOTE_NAME}\` with path \`${GIT_REMOTE_PATH_ACTUAL}\` exists"
  echo "ERROR: Remote \`${GIT_REMOTE_NAME}\` path does not match \`${GIT_REMOTE_PATH}\`"
  echo "Hint: Run \`git remote set-url ${GIT_REMOTE_NAME} ${GIT_REMOTE_PATH}\` and try again"
  exit 1
fi
for REF in ${GIT_REFS_TO_PUSH}; do
  git push -f ${GIT_REMOTE_NAME} ${REF} > /dev/null
  STATUS="${?}"
  if [ "x${STATUS}" != "x0" ]; then
    echo "ERROR: Failed to push \`${REF}\` to the remote ${GIT_REMOTE_NAME}"
    exit 1
  fi
done


# vim: set ts=2 sw=2 tw=0 et :


