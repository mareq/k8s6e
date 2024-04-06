# Kubernetes Cluster

An example Kubernetes cluster with working examples.

## Dependencies

- [docker](https://docs.docker.com/engine/install/debian/#install-using-the-repository)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management)
- [kustomize](https://github.com/kubernetes-sigs/kustomize/releases)
- [k9s](https://github.com/derailed/k9s/releases) (optional, but strongly recommended)

## Contents

### Kubernetes Cluster

- [KinD](./cluster/kind/README.md): Local Kubernetes cluster using Docker container "nodes".
- _MiniKube_: Lightweight local Kubernetes cluster. [TODO]

- [Common](./cluster/common/README.md): Common general cluster configuration/deployments.

### Debug

- [Debug](./debug/shell/README.md): The troubleshooting pod providing interactive shell running inside the Kubernetes cluster.

