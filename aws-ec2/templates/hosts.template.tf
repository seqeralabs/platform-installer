## File output configuration
resource "local_file" "output_file" {
  count           = 1
  content         = <<EOF
export TOWER_HOSTNAME=${module.terraform-seqera-aws.ec2_instance_public_dns_name}
export TOWER_DB_HOSTNAME=${module.terraform-seqera-aws.database_url}
export TOWER_REDIS_HOSTNAME=${module.terraform-seqera-aws.redis_url}
EOF
  filename        = "hosts.sh"

}
