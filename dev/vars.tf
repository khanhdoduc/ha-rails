variable "AWS_REGION" {
  default = "ap-northeast-1"
}

variable "ENV" {
  default = "dev"
}

variable "AMIS" {
  type = "map"

  default = {
    ap-northeast-1 = "ami-0ff21806645c5e492"
  }
}

variable "RDS_PASSWORD" {}

variable "PATH_TO_PUBLIC_KEY" {
  default = "khanh-infra.pub"
}
