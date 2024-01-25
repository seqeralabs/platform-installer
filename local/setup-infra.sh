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

# Install MySQL, Redis and SMTP server

kubectl apply -n $TOWER_NAMESPACE -f <(cat k8s/infra.yml | envsubst)

is_pod_ready() {
    kubectl get pod "$1" 2>/dev/null | grep "1/1" | grep "Running" | grep "Terminating" -v
}

wait_for() {
  echo "Waiting for pod $1 to be ready..."
  while ! is_pod_ready $1; do
      sleep 5
  done
}

wait_for 'mysql-0'

#
# Create "tower" schema
#
export DDL="\
 CREATE DATABASE IF NOT EXISTS ${TOWER_DB_SCHEMA} CHARACTER SET utf8 COLLATE utf8_bin;\
 CREATE USER IF NOT EXISTS ${TOWER_DB_USER} IDENTIFIED BY '${TOWER_DB_PASSWORD}';\
 GRANT ALL PRIVILEGES ON ${TOWER_DB_USER}.* TO ${TOWER_DB_USER}@'%';\
 "

bash ./mysql-ddl.sh

#
# Create "groundswell" schema
#
export DDL="\
 CREATE DATABASE IF NOT EXISTS ${SWELL_DB_SCHEMA} CHARACTER SET utf8 COLLATE utf8_bin;\
 CREATE USER IF NOT EXISTS ${SWELL_DB_USER} IDENTIFIED BY '${SWELL_DB_PASSWORD}';\
 GRANT ALL PRIVILEGES ON ${SWELL_DB_USER}.* TO ${SWELL_DB_USER}@'%';\
 "

bash ./mysql-ddl.sh
