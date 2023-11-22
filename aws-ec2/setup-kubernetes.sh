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
source hosts.sh
source settings.sh

k3sup install --host $TOWER_HOSTNAME --user ec2-user

# define the current kubeconfig file
export KUBECONFIG=$PWD/kubeconfig

# create the target namespace
kubectl create namespace $TOWER_NAMESPACE
kubectl config set-context --current --namespace=$TOWER_NAMESPACE


