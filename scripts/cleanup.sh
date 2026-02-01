#!/bin/bash
set -e

echo "Cleaning previous deployment directory..."

rm -rf /home/ubuntu/portfolio
mkdir -p /home/ubuntu/portfolio
chown -R ubuntu:ubuntu /home/ubuntu/portfolio