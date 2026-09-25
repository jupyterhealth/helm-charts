#!/bin/bash

set -ex

ns="jhe-test"
name="jhe-test"
kubectl create ns $ns || true
helm upgrade --install --namespace $ns $name ./jhe --values jhe/ci/ow-values.yaml

kubectl rollout -n jhe-test status deployments/$name-postgres --timeout=60s
kubectl rollout -n jhe-test status deployments/$name --timeout=60s
# restart to make sure it's re-loaded after seed
kubectl rollout -n jhe-test restart deployments/$name
kubectl rollout -n jhe-test status deployments/$name --timeout=60s
