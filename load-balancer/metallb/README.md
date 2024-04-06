# MetalLB

Kubernetes does not provide an implementation of network load balancers for bare-metal clusters such as [KinD](../../kind/README.md). Therefore the [Services](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/) of type [LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) will indefinitely remain in "pending" state and will never get any external IP assigned to them. There exist several substandard workarounds, such as using [Services](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/) of type [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport). MetalLB offers the solution to this problem by providing the mechanism of assigning external IP addresses from the configured ranges to the [Services](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/) of type [LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer).

The ranges for the external IP addresses used by MetalLB is specified in its [IPAddressPool](https://metallb.universe.tf/apis/#ipaddresspool) resource (see the [config file](./manifests/metallb-config.yaml)). These ranges must be compatible with the Docker network assigned to the Kubernetes cluster (e.g. `kind` for KinD cluster), so that the external network traffic is correctly routed by Docker into the Kubernetes cluster.

## Usage

- scripts
  - [get-manifests.sh](./get-manifests.sh): Download MetalLB manifests from the official source.
  - [make-ip-range-patch.sh](./make-ip-range-patch.sh): Create a patch for Kustomize to set the correct IP range. This patch is used by the [start.sh](./start.sh) script.
  - [start.sh](./start.sh): Install MetalLB into the running Kubernetes cluster.
  - [stop.sh](./stop.sh): Remove MetalLB and associated resources.

## Resources

- [Official website](https://metallb.universe.tf)
- [KinD LoadBalancer documentation](https://kind.sigs.k8s.io/docs/user/loadbalancer/)


