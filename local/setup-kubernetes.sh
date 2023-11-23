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

# setup the k3d cluster
# note, it maps the ports 8000 used by Seqera frontend to port 80 of the LB 
k3d cluster create seqera-platform -p "8000:80@loadbalancer"

# create the target namespace
kubectl create namespace $TOWER_NAMESPACE
kubectl config set-context --current --namespace=$TOWER_NAMESPACE


