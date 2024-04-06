# Debug Shell

The troubleshooting pod for providing the interactive debugging shell running inside the Kubernetes cluster. It is a bare-bones Debian system, with a small set of various debugging tools pre-installed. More can be added ad-hoc as/if needed by use of `apt`.

## Usage

- scripts
  - [start.sh](./start.sh): Install the interactive shell pod.
  - [stop.sh](./stop.sh): Remove the interactive shell pod and associated resources.


