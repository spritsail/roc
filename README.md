[hub]: https://hub.docker.com/r/spritsail/roc
[drone]: https://drone.spritsail.io/spritsail/roc

# [Spritsail/ROC][hub]

[![Docker Pulls](https://img.shields.io/docker/pulls/spritsail/roc.svg)][hub]
[![Docker Stars](https://img.shields.io/docker/stars/spritsail/roc.svg)][hub]
[![Build Status](https://drone.spritsail.io/api/badges/spritsail/roc/status.svg)][drone]

An Alpine Linux based Dockerfile for the ROC audio toolkit - primarily `roc-send` & `roc-recv`.   
The default command runs `roc-recv` with a rs8m repair channel on the default ports, and expects a **file** mapped to a volume to `/audio` in the container. 

`roc-send` is also available in the container for the reverse operation.

## Example run command
```
docker run -d --name roc-recv -v /host/path/to/fifo:/audio  -p 10001:10001/udp -p 10002:10002/udp spritsail/roc
```