#!/bin/bash
set -e

docker stop portfolio || true
docker rm portfolio || true