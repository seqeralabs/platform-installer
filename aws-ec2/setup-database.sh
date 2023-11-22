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

DDL="\
 ALTER DATABASE ${TOWER_DB_SCHEMA} CHARACTER SET utf8 COLLATE utf8_bin;\
 CREATE USER IF NOT EXISTS ${TOWER_DB_USER} IDENTIFIED BY '${TOWER_DB_PASSWORD}';\
 GRANT ALL PRIVILEGES ON ${TOWER_DB_USER}.* TO ${TOWER_DB_USER}@'%';\
 "

kubectl delete pod mysql-client &> /dev/null
kubectl run -it --rm \
  --image=mysql:latest \
  --restart=Never \
  mysql-client \
  -- mysql -h $TOWER_DB_HOSTNAME \
    -u $TOWER_DB_ADMIN_USER \
    -p$TOWER_DB_ADMIN_PASSWORD \
    -e "$DDL"  \
    && echo "Database schema configured successfully."
