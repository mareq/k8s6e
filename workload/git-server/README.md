# Git Server

A server providing access to a git repositories.

## Usage

- scripts
  - [make_repo.sh](./make_repo.sh): Initialize the host bare repository at [./repositories/k8s6r.git/](./repositories/k8s6r.git/) as the `local` remote for this Git repository.
  - [delete_repo.sh](./delete_repo.sh): Remove the host bare repository at [./repositories/k8s6r.git/](./repositories/k8s6r.git/).
  - [start.sh](./start.sh): Deploy the Git server providing the Git repositories over HTTP, using the ["smart" HTTP Git protocol](https://git-scm.com/book/en/v2/Git-on-the-Server-The-Protocols#_smart_http). It serves the Git repositories, present in the [repositories](./repositories) subdirectory.
    - The script uses the `kind-bootstrap` Kustomize overlay by default. This does not deploy the [Ingress](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/ingress-v1/), so that the Git server is visible only from inside the cluster.
    - The primary purpose of the [./repositories/k8s6r.git/](./repositories/k8s6r.git/) repository being served is to provide the source of the manifests for a GitOps tool.
    - A GitOps tool, once set up, will use the `kind` Kustomize overlay, which will deploy also the [Ingress](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/ingress-v1/), making the Git server available also from outside the Kubernetes cluster.
  - [stop.sh](./stop.sh): Remove the Git server and associated resources.

The [./repositories/k8s6r.git/](./repositories/k8s6r.git/) repository is accessible at the following addresses:
  - from inside the cluster: `git clone http://nginx-smart-http.git-server.svc.cluster.local/git/smart/k8s6r.git`
  - from outside the cluster: `git clone http://example.tld/git/smart/k8s6r.git`

Note that the Git server uses plain HTTP protocol, even for the connections from outside the Kubernetes cluster. This is a clar no-no in any serious setting, but setting up SSL is outside of the scope of this simple demonstration.


