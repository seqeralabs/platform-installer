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

##
# define the requirement parameters to deploy Seqera platform
## 

# The Kubernetes namespace where the Seqera platform will be installed
export TOWER_NAMESPACE='seqera-platform'

# The HTTP URL to access the Seqera platform service. The hostname must match the variable `TOWER_APP_HOSTNAME`
# Do not include any ending slash character.
export TOWER_SERVER_URL="http://${TOWER_APP_HOSTNAME}"

# The email address that will be used as sender when delivering email notification by Seqera platform, e.g.
# "seqera-platform@company.com"
export TOWER_CONTACT_EMAIL='<PLATFORM SENDER EMAIL>'

# Secret used to generate the login JWT token. Use a long random string (35 chars or more).
export TOWER_JWT_SECRET='<REPLACE WITH A RANDOM STRING>'

# Relational DB schema name used by Seqera platform. Default "tower"
export TOWER_DB_SCHEMA='tower'

# Relational DB username used by Seqera platform. Default "tower".
export TOWER_DB_USER='tower'

# Relational DB password used by Seqera platform.
export TOWER_DB_PASSWORD='<REPLACE WITH THE DB PASSWORD>'

# Relational DB admin username used by Seqera platform. Default "admin".
export TOWER_DB_ADMIN_USER='admin'

# Relational DB admin password used by Seqera platform.
export TOWER_DB_ADMIN_PASSWORD='<REPLACE WITH THE DB PASSWORD>'

# Key used to encrypt secrets. Use a long random string (25 chars or more).
# **NOTE**: Save this in a safe manner. Losing or changing it will make impossible to recover secrets stored by Seqera platform
export TOWER_CRYPTO_SECRETKEY='<REPLACE WITH A RANDOM STRING>'

# Your Tower license key. If you don't have a license key contact sales@seqera.io
export TOWER_LICENSE='<REPLACE WITH YOUR SEQERA PLATFORM LICENSE KEY>'

# The ARN of the certificate created visa AWS Certificate manager matching the domain specified by the parameter 'TOWER_SERVER_NAME'
# Note:
#  - The certificate must be created in the same AWS region where the cluster is deployed
#  - The certificate should must the domain and any sub-domain e.g. "platform.company.com" and "*.platform.company.com"
#  - Only for public facing access, ignore otherwise
export TOWER_HTTPS_CERTIFICATE_ARN='<REPLACE WITH THE CERTIFICATE ARN>'

# The username to access the Seqera container registry to providing the images for installing Seqera platform.
# If you don't have it contact sales@seqera.io
# NOTE: wrap the username in single quotes
export SEQERA_CR_USER='<REPLACE WITH YOUR SEQERA CONTAINER REGISTRY USERNAME>'

# The password to access the Seqera container registry to providing the images for installing Seqera platform.
# If you don't have it contact sales@seqera.io
# NOTE: wrap the username in single quotes
export SEQERA_CR_PASSWORD='<REPLACE WITH YOUR SEQERA CONTAINER REGISTRY PASSWORD>'

##
## AWS and cluster settings
##

# The AWS region where the cluster will be deployed e.g. "eu-west-1"
export AWS_REGION='<REPLACE WITH THE DESIRED AWS REGION>'

# The AWS configuration profile used to setup and deploy the cluster e.g. "deploy-seqera-platform"
export AWS_PROFILE='<REPLACE WITH THE DESIRED AWS CONFIG PROFILE>'

# The ARN of the AWS user that will operate the EKS cluster
export AWS_USER_ARN='<REPLACE WITH THE ARN OF THE AWS USER>'

# The name of the VPC that will be created to setup Seqera platform
export AWS_VPC_NAME='seqera-platform-vpc'

# The instance type used to run the EKS cluster
# If you want to use more than one, edit the corresponding value in the "main.nf" file
export AWS_EC2_INSTANCE_TYPE='m5a.2xlarge'

# Groundswell config
export SWELL_DB_SCHEMA=groundswell
export SWELL_DB_USER=groundswell

# Relational DB password used by Seqera Groundswell.
export SWELL_DB_PASSWORD='<REPLACE WITH THE DB PASSWORD>'
