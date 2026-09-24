#!/bin/bash

set -ex

ns="jhe-test"
name="jhe-test"
kubectl create ns $ns || true
helm upgrade --install --namespace $ns $name ./jhe --values tests/test_values.yaml --skip-schema-validation

kubectl rollout -n jhe-test status deployments/$name-postgres --timeout=60s
kubectl rollout -n jhe-test status deployments/$name --timeout=60s
# restart to make sure it's re-loaded after seed
kubectl rollout -n jhe-test restart deployments/$name
kubectl rollout -n jhe-test status deployments/$name --timeout=60s
