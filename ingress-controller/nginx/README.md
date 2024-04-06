# NginX Ingress

Ingress controller is backing the [Ingress](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/ingress-v1/). It manages external access to services within the cluster, typically via HTTP or HTTPS, by routing traffic based on rules defined in [Ingress](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/ingress-v1/) resources.

## Usage

- scripts
  - [get-manifests.sh](./get-manifests.sh): Download NginX Ingress Controller manifests from the official Helm repository.
  - [start.sh](./start.sh): Install NginX Ingress Controller into the running Kubernetes cluster.
  - [stop.sh](./stop.sh): Remove NginX Ingress Controller and associated resources.

The ingress [Service](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/) of type [LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer) will be created by the NginX Ingress Controller. If there is a network load balancer (such as [MetalLB](../../load-balancer/metallb/README.md) on [KinD](../../cluster/kind/README.md) cluster) running, it will assign an external IP address to the ingress [Service](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/). This IP address can be obtained by running the following command (if this command fails, or if it returns an empty result, there is a problem with at least one of the components):
```sh
$ kubectl get --namespace ingress-nginx service ingress-nginx-controller --output json | jq -r '.status.loadBalancer.ingress[0].ip'
```
This address can be then used to set up the DNS record (for production clusters) or a record in `/etc/hosts` (for local clusters):
```sh
# echo "$(kubectl get --namespace ingress-nginx service ingress-nginx-controller --output json | jq -r '.status.loadBalancer.ingress[0].ip) example.tld" >> /etc/hosts
```

## Resources

- [Official website](https://kubernetes.github.io/ingress-nginx/)
- [GitHub repository](https://github.com/kubernetes/ingress-nginx)


