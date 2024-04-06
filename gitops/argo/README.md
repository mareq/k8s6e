# ArgoCD

Declarative GitOps continuous delivery tool.

## Contents

There are three separate groups of Kustomize manifests:

- [argo](./manifests/argo/base/kustomization.yaml): The ArgoCD itself.
  - [base](./manifests/argo/base/kustomization.yaml)
    - [namespace.yaml](./manifests/argo/base/namespace.yaml): ArgoCD namespace
    - [base/argo-cd.yaml](./manifests/argo/base/argo-cd.yaml): ArgoCD deployment manifests
  - overlays
    - [kind](./manifests/argo/overlays/kind/kustomization.yaml): use plain HTTP, disable ArgoCD components not needed for the demo-purposes

- [app-of-apps](./manifests/app-of-apps/base/kustomization.yaml): The "App-of-Apps" [Application](https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/).
  - [base](./manifests/app-of-apps/base/kustomization.yaml)
    - [git-repository.yaml](./manifests/app-of-apps/base/git-repository.yaml): Definition of Git repository for ArgoCD to use as source for deployment files. (Used only by ArgoCD UI.)
    - [application_app-of-apps.yaml](./manifests/app-of-apps/base/application_app-of-apps.yaml): "App-of-Apps" [Application](https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/) for self-management pointing at `manifests/app-of-apps` (self).
    - [application_apps.yaml](./manifests/app-of-apps/base/application_apps.yaml): The child [Applications](https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/) pointing at `manifests/apps`.
  - overlays
    - [kind](./manifests/argo/overlays/kind/kustomization.yaml): use plain HTTP, disable ArgoCD components not needed for the demo-purposes

- [apps](./manifests/apps/base/kustomization.yaml): The child [Applications](https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/) manged by the "App-of-Apps".
  - [base](./manifests/apps/base/kustomization.yaml)
    - [argo-cd.yaml](./manifests/apps/base/argo-cd.yaml): ArgoCD [Application](https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/), pointing at `manifests/argo`. This sets up ArgoCD self-management.
    - [debug-shell.yaml](./manifests/apps/base/debug-shell.yaml): [Debug Shell](../../debug/shell/README.md) [Application](https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/).
    - [ingress-nginx.yaml](./manifests/apps/base/ingress-nginx.yaml): [NginX Ingress Controller](../../ingress-controller/nginx/README.md) [Application](https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/).
    - [static-page.yaml](./manifests/apps/base/static-page.yaml): [Static Page](../../workload/static-page/README.md) [Application](https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/).
  - overlays
    - [kind](./manifests/apps/overlays/kind/kustomization.yaml)
      - [git-server_nginx-smart-http.yaml](./manifests/apps/overlays/kind/git-server_nginx-smart-http.yaml]): [Git Server](../../workload/git-server/README.md) [Application](https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/). This is specific to [KinD](../../cluster/kind/README.md) cluster. An external repository (e.g. hosted on [GitHub](https://github.com/)) would typically be used as the source of deployment files for GitOps tools in a real-world production scenario.
      - [load-balancer_metallb.yaml](./manifests/apps/overlays/kind/load-balancer_metallb.yaml]): [MetalLB Load Balancer](../../load-balancer/metallb/README.md) [Application](https://argo-cd.readthedocs.io/en/stable/user-guide/application-specification/). A Cloud-based Kubernetes cluster would typically have load-balancer provided by the Cloud provider. This is needed only for bare-metal clusters, such as [KinD](../../cluster/kind/README.md).

## Usage

- scripts
  - [get-manifests.sh](./get-manifests.sh): Download ArgoCD manifests from the official source.
  - [start.sh](./start.sh): Deploy ArgoCD and set it up to manage the Kubernetes cluster, including self-management.
  - [stop.sh](./stop.sh): Remove ArgoCD and associated resources.
  - [port-forward.sh](./port-forward.sh): Set up port-forwarding to open access to ArgoCD from the host.
    - The ArgoCD server is available at [http://localhost:1875](http://localhost:1875).
    - The login credentials are output to `stdout` by the script prior to setting up the port forwarding.

- [CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/):
  - install
    ```sh
    $ curl -L https://github.com/argoproj/argo-cd/releases/download/v2.10.6/argocd-linux-amd64 -o "${HOME}/.local/bin/argocd"
    ```
  - login (use credentials printed out by the [port-forward.sh](./port-forward.sh) script)
    ```
    $ argocd login localhost:1875
    WARNING: server is not configured with TLS. Proceed (y/n)? y
    Username: admin
    Password:
    'admin:login' logged in successfully
    Context 'localhost:1875' updated
    ```
  - smoke test
    ```
    $ argocd cluster list
    SERVER                          NAME        VERSION  STATUS      MESSAGE  PROJECT
    https://kubernetes.default.svc  in-cluster  1.29     Successful
    ```
Note that the CLI tool speaks to the ArgoCD server, therefore the port-forward needs to be kept open for it to work.

## Resources

- [Official website](https://argo-cd.readthedocs.io/en/stable/)
- [Burak Kurt: Self Managed Argo CD - App Of Everything](https://medium.com/devopsturkiye/self-managed-argo-cd-app-of-everything-a226eb100cf0)
- [Arthur Koziel: Setting up Argo CD with Helm](https://www.arthurkoziel.com/setting-up-argocd-with-helm/)


