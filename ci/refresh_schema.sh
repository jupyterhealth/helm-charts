#!/usr/bin/env bash

set -ex
charts="jhe"
for chart in $charts; do
    pushd "$chart"
    helm schema
    popd
done
