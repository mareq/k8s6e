# Kubernetes Cluster

An example Kubernetes cluster with working examples.

## Dependencies

- [docker](https://docs.docker.com/engine/install/debian/#install-using-the-repository)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-using-native-package-management)
- [kustomize](https://github.com/kubernetes-sigs/kustomize/releases)
- [k9s](https://github.com/derailed/k9s/releases) (optional, but strongly recommended)
- [jq](https://jqlang.github.io/jq/)
- [yq (Go alternative)](https://github.com/mikefarah/yq)
  ```sh
  $ go install github.com/mikefarah/yq/v4@v4.34.2
  ```
  The `v4.34.2` is the most recent version that still works with version of Go (`v1.19.8`) available on stable Debian (Bookworm).

  Note that the [Python alternative](https://github.com/kislyuk/yq) available via `apt install yq` will **NOT** work, because it:
    - converts YAML to JSON by default (no `-o` argument)
    - does not parse JSON (unknown argument `-p`), which is why it is not used here

  Make sure that it is either not installed or the `$PATH` is set such that the Go alternative (usually installed into `${HOME}/.local/share/go/bin/yq`) is used.

## Contents

### Kubernetes Cluster

- [KinD](./cluster/kind/README.md): Local Kubernetes cluster using Docker container "nodes".
- _MiniKube_: Lightweight local Kubernetes cluster. [TODO]

- [Common](./cluster/common/README.md): Common general cluster configuration/deployments.

### Debug

- [Debug](./debug/shell/README.md): The troubleshooting pod providing interactive shell running inside the Kubernetes cluster.

### Load Balancer

- [MetalLB](./load-balancer/metallb/README.md): Load balancer for bare metal Kubernetes clusters (such as KinD).

### Ingress Controller

- [NginX](./ingress-controller/nginx/README.md): Ingress Controller based on NginX.
- _Traefik_: Traefik Ingress Controller based on Traefik. [TODO]

### Workload

- [Static Page](./workload/static-page/README.md): Simple static web page.
- [Git Server](./workload/git-server/README.md): Git server providing access to repositories over HTTP.


