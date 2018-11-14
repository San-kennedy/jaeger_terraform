#!/bin/bash

#get both the UI and collector binaries

set -e

wget -P /opt https://github.com/jaegertracing/jaeger/releases/download/v1.7.0/jaeger-1.7.0-linux-amd64.tar.gz

cd /opt

tar -xvzf jaeger-1.7.0-linux-amd64.tar.gz
