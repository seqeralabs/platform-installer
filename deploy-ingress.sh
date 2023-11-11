#!/usr/bin/env bash
source settings.sh
## Deploy the Seqera platform
kubectl apply -n $TOWER_NAMESPACE -f <(cat k8s/ingress.yml | envsubst)
