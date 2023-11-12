
## Module
module "terraform-seqera-module" {
  source  = "github.com/seqeralabs/terraform-seqera-module?ref=2d32b27daee63dddb81a92cde19405f12edf7223"
  region  = "${AWS_REGION}"
  aws_profile = "${AWS_PROFILE}"
  seqera_namespace_name = "${TOWER_NAMESPACE}"

  ## The setting of the VPC to be created

  ## VPC
  vpc_name = "${AWS_VPC_NAME}"

  ## customer has to choose the correct VPC
  vpc_cidr = "10.0.0.0/16"

  azs                 = ["${AWS_REGION}a", "${AWS_REGION}b", "${AWS_REGION}c"]
  private_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets      = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  database_subnets    = ["10.0.104.0/24", "10.0.105.0/24", "10.0.106.0/24"]
  elasticache_subnets = ["10.0.107.0/24", "10.0.108.0/24", "10.0.109.0/24"]
  intra_subnets       = ["10.0.110.0/24", "10.0.111.0/24", "10.0.112.0/24"]

  ## EKS
  cluster_name    = "${AWS_EKS_CLUSTER_NAME}"
  cluster_version = "1.27"

  ## TODO Review instance type 
  eks_managed_node_group_defaults_instance_types = ["${AWS_EKS_INSTANCE_TYPE}"]
  eks_managed_node_group_defaults_capacity_type = "ON_DEMAND"
  
  ## user with AdministratorAccess policy
  eks_aws_auth_users = [ "${AWS_USER_ARN}" ]

  ## DB settings
  db_root_username = "${TOWER_DB_ADMIN_USER}"
  db_app_schema_name = "${TOWER_DB_SCHEMA}"
  db_app_username = "${TOWER_DB_USER}"

  default_tags = {
    ManagedBy   = "Terraform"
    Product     = "SeqeraPlatform"
  }

}

## Outputs
output "TOWER_DB_HOSTNAME" {
  value = module.terraform-seqera-module.database_url
}

output "TOWER_REDIS_HOSTNAME" {
  value = module.terraform-seqera-module.redis_url
}


### where the terraform state is persisted

terraform {
  backend "s3" {
    ## the bucket must exist
    bucket  = "${AWS_TF_STATE_BUCKET}"
    key     = "${AWS_TF_STATE_KEY}"
    region  = "${AWS_REGION}"
    profile = "${AWS_PROFILE}"
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "${AWS_REGION}"
  profile = "${AWS_PROFILE}"
}
