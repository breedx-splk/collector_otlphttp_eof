#!/bin/bash

set -e

if [ ! -e otelcol-contrib ] ; then
  curl -L -o otelcol-contrib.tgz https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.83.0/otelcol-contrib_0.83.0_darwin_amd64.tar.gz
  tar -xvzf otelcol-contrib.tgz otelcol-contrib
fi

./otelcol-contrib --config repro.yaml
