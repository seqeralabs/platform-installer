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
set -e

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
