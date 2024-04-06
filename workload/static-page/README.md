# Static Page

A simple static web page, demonstrating the basic use-case of deploying a workload in Kubernetes cluster and routing the external traffic to it.

## Usage

- scripts
  - [start.sh](./start.sh): Deploy the static web page workload into the running Kubernetes cluster.
  - [stop.sh](./stop.sh): Remove static web page workload and associated resources.

Provided that the ingress controller (e.g. [NginX Ingress](../../ingress-controller/nginx/README.md)) and the load balancer (e.g. [MetalLB](../../load-balancer/metallb/README.md)) are up and running, and the appropriate DNS name is set up (e.g. record in `/etc/hosts`), the static web page can be accessed via a web browser at [http://example.tld](http://example.tld) form outside of the Kubernetes cluster (the host name depends on the DNS name setup).


