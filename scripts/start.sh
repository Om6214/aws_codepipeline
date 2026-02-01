#!/bin/bash
set -e

IMAGE="om6214/portfolio-image:latest"

/usr/bin/docker pull $IMAGE

/usr/bin/docker stop portfolio || true
/usr/bin/docker rm portfolio || true

/usr/bin/docker run -d \
  --name portfolio \
  -p 3000:3000 \
  --env-file /etc/portfolio/env \
  $IMAGE