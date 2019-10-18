module "s3" {
  source = "../modules/s3"
}

# module "cloudfront" {
#   source                      = "../modules/cloudfront"
#   ENV                         = "dev"
#   S3_BUCKET_NAME              = "${module.s3.s3_media_bucket}"
#   BUCKET_REGIONAL_DOMAIN_NAME = "${module.s3.s3_media_regional_domain}"
# }

module "main-vpc" {
  source     = "../modules/vpc"
  ENV        = "dev"
  AWS_REGION = "${var.AWS_REGION}"
}

module "security-groups" {
  source = "../modules/securitygroups"
  ENV    = "dev"
  VPC_ID = "${module.main-vpc.vpc_id}"
  SOURCE_SG = "${module.linux2ami-instance.bastion_sg}"
}

module "mysql-rds" {
  source          = "../modules/rds"
  ENV             = "dev"
  PRIVATE_SUBNETS = "${module.main-vpc.private_subnets}"
  SECURITY_GROUP  = "${module.security-groups.rds_launch_id}"
  RDS_PASSWORD    = "${var.RDS_PASSWORD}"
}

module "linux2ami-instance" {
  source              = "../modules/instances"
  ENV                 = "dev"
  AMI                 = "${lookup(var.AMIS, var.AWS_REGION)}"
  # USER_DATA           = "${file("scripts/csa-ha-wp-bash.sh")}"
  # USER_DATA_FOR_SCALE = "${file("scripts/csa-ha-wp-bash-scale.sh")}"
  PUBLIC_SUBNETS      = "${module.main-vpc.public_subnets}"
  PRIVATE_SUBNETS     = "${module.main-vpc.private_subnets}"
  SECURITY_GROUP      = "${module.security-groups.web_dmz_id}"
  TARGET_GROUP_ARN    = "${module.alb.target_group_arn}"
  VPC_ID              = "${module.main-vpc.vpc_id}"
  BASTION_BUCKET      = "${module.s3.bastion_bucket_name}"
}

module "alb" {
  source         = "../modules/alb"
  ENV            = "dev"
  VPC_ID         = "${module.main-vpc.vpc_id}"
  SECURITY_GROUP = "${module.security-groups.elb_id}"
  PUBLIC_SUBNETS = "${module.main-vpc.public_subnets}"
  PRIVATE_SUBNETS     = "${module.main-vpc.private_subnets}"
  INSTANCE_ID    = "${module.linux2ami-instance.instance_id}"
}



