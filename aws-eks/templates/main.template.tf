
## Module
module "terraform-seqera-aws" {
  source  = "github.com/seqeralabs/terraform-seqera-aws?ref=v0.7.1"
  region  = "${AWS_REGION}"
  seqera_namespace_name = "${TOWER_NAMESPACE}"

  ## VPC settings
  vpc_name = "${AWS_VPC_NAME}"
  vpc_cidr = "10.0.0.0/16"

  private_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets      = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  ## EKS
  create_eks_cluster = true
  cluster_name    = "${AWS_EKS_CLUSTER_NAME}"
  cluster_version = "1.27"

  ## Review instance type 
  eks_managed_node_group_defaults_instance_types = ["${AWS_EKS_INSTANCE_TYPE}"]
  eks_managed_node_group_defaults_capacity_type = "ON_DEMAND"
  
  ## user with AdministratorAccess policy
  eks_aws_auth_users = [ "${AWS_USER_ARN}" ]

  ## DB settings
  db_root_username = "${TOWER_DB_ADMIN_USER}"
  db_app_schema_name = "${TOWER_DB_SCHEMA}"
  db_app_username = "${TOWER_DB_USER}"

  redis_instance_type = "cache.m4.xlarge"
  db_instance_class = "db.r5.xlarge"

  default_tags = {
    ManagedBy   = "Terraform"
    Product     = "SeqeraPlatform"
  }

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
