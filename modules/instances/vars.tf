variable "ENV" {}
variable "AMI" {}
# variable "USER_DATA" {}
# variable "USER_DATA_FOR_SCALE" {}

variable "PATH_TO_PUBLIC_KEY" {
  default = "khanh-infra.pub"
}

variable "INSTANCE_TYPE" {
  default = "t2.micro"
}

variable "PUBLIC_SUBNETS" {
  type = "list"
}

variable "PRIVATE_SUBNETS" {
  type = "list"
}

variable "SECURITY_GROUP" {}

variable "TARGET_GROUP_ARN" {}

variable "VPC_ID" {}

variable "BASTION_BUCKET" {
  
}

