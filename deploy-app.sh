#!/usr/bin/env bash
source settings.sh

## create Seqera container registry credentials
kubectl delete secret reg-creds || true
kubectl create secret docker-registry reg-creds \
  --namespace seqera-platform \
  --docker-server=cr.seqera.io \
  --docker-username="$SEQERA_CR_USER" \
  --docker-password="$SEQERA_CR_PASSWORD"

# hack to keep 
export TOWER_REDIS_HOSTNAME='${TOWER_REDIS_HOSTNAME}'
export TOWER_DB_HOSTNAME='${TOWER_DB_HOSTNAME}'

## Create K8s config map for Seqera platform
kubectl apply -n $TOWER_NAMESPACE -f <(cat k8s/config.yml | envsubst)

## Deploy the Seqera platform
kubectl apply -n $TOWER_NAMESPACE -f <(cat k8s/platform.yml | envsubst)
