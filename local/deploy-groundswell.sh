#!/usr/bin/env bash
#
# Copyright 2023, Seqera Labs
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
source settings.sh
source settings-groundswell.sh

#
# create DB schema
#
export DDL="\
 CREATE DATABASE IF NOT EXISTS ${SWELL_DB_SCHEMA} CHARACTER SET utf8 COLLATE utf8_bin;\
 CREATE USER IF NOT EXISTS ${SWELL_DB_USER} IDENTIFIED BY '${SWELL_DB_PASSWORD}';\
 GRANT ALL PRIVILEGES ON ${SWELL_DB_USER}.* TO ${SWELL_DB_USER}@'%';\
 "

bash ./mysql-ddl.sh

#
# deploy groundswell app
#
kubectl apply -n $TOWER_NAMESPACE -l group=groundswell -f <(kubectl kustomize ./k8s-groundswell --load-restrictor=LoadRestrictionsNone | envsubst)

#
# Update Platform config and reload platform backend and cron to apply changes
#
kubectl apply -n $TOWER_NAMESPACE -l group=config -f <(kubectl kustomize ./k8s-groundswell --load-restrictor=LoadRestrictionsNone | envsubst)
kubectl rollout restart deployment/cron
kubectl rollout restart deployment/backend


