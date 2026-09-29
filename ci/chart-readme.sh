#!/bin/bash
set -ex
docker run --rm -it -v "$PWD:/helm-docs" -u "$(id -u)" jnorwood/helm-docs:v1.14.2 -t README.tpl.md --sort-values-order file
