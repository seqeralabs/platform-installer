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

module "terraform-seqera-aws" {
  source  = "github.com/seqeralabs/terraform-seqera-aws?ref=v0.7.0"
  region  = "${AWS_REGION}"
  ## VPC
  vpc_name = "${AWS_VPC_NAME}"
  ## EC2 Instance
  ec2_instance_type = "${AWS_EC2_INSTANCE_TYPE}"
  create_ec2_instance = true
  create_ec2_instance_local_key_pair = true
  create_ec2_public_instance = true
  default_tags = {
    ManagedBy   = "Terraform"
    Product     = "SeqeraPlatform"
  }
  # DB settings
  db_app_username = "${TOWER_DB_USER}"
  db_app_password = "${TOWER_DB_PASSWORD}"
  db_root_username = "${TOWER_DB_ADMIN_USER}"
  db_root_password = "${TOWER_DB_ADMIN_PASSWORD}"
}

# Configure the AWS Provider
provider "aws" {
  region  = "${AWS_REGION}"
  profile = "${AWS_PROFILE}"
}
