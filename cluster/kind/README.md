# KinD

Local Kubernetes cluster using Docker container "nodes".

## Install

```sh
$ go install sigs.k8s.io/kind@latest
```

Or download binary from the official [releases page](https://github.com/kubernetes-sigs/kind/releases).

## Usage

- configuration: [cluster.yaml](./config/actual/cluster.yaml)
  - 1x Control Plane node, 1x Worker node.
  - Each [Node](https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/node-v1/) has the root of this Git repository mounted at `/mnt/hostfs/`.

- scripts
  - [start.sh](./start.sh): Generate the [cluster.yaml](./config/actual/cluster.yaml) and start up the KinD cluster.
  - [stop.sh](./stop.sh): Tear down the cluster.
  - [status.sh](./status.sh): Show raw Docker stats for all currently running containers.

## Resources

- [Official website](https://kind.sigs.k8s.io/)


