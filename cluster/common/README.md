# Common

Common general cluster configuration/deployments, independent of the cluster type.

## Contents

- persistent volume: [persistent-volume.yaml](./manifests/base/persistent-volume.yaml)
  - The [PersistentVolume](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/persistent-volume-v1/) backed by the host filesystem mounted at `/mnt/hostfs/` on each [Node](https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/node-v1/).

## Usage

- scripts
  - [start.sh](./start.sh): Deploy the common deployments.
  - [stop.sh](./stop.sh): Remove the common deployments.


