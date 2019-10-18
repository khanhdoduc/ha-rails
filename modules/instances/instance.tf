
module "bastion-host" {
  source                      = "github.com/terraform-community-modules/tf_aws_bastion_s3_keys"
  instance_type               = "t2.nano"
  name                        = "infra-${var.ENV}-bastion"
  ami                         = "ami-02ab8cc551ec6d7a9"
  region                      = "ap-northeast-1"
  key_name                    = "${aws_key_pair.infra-key.key_name}"
  iam_instance_profile        = "${aws_iam_instance_profile.s3-infra-readonly-role-instanceprofile.name}"
  s3_bucket_name              = "${var.BASTION_BUCKET}"
  vpc_id                      = "${var.VPC_ID}"
  subnet_ids                  = "${var.PUBLIC_SUBNETS}"
  keys_update_frequency       = "*/15 * * * *"
  additional_user_data_script = "date"
  associate_public_ip_address = true
  ssh_user = "ec2-user"
}

resource "aws_instance" "instance" {
  ami           = "${var.AMI}"
  instance_type = "${var.INSTANCE_TYPE}"

  # the VPC subnet
  subnet_id = "${var.PRIVATE_SUBNETS[0]}"
  
  # the security group
  vpc_security_group_ids = ["${var.SECURITY_GROUP}"]

  # the public SSH key
  key_name  = "${aws_key_pair.infra-key.key_name}"
  # user_data = "${var.USER_DATA}"

  iam_instance_profile = "${aws_iam_instance_profile.s3-infra-all-role-instanceprofile.name}"

  tags {
    Name         = "linux2ami-instance"
    Terraform    = "true"
    Environmnent = "${var.ENV}"
  }
}

output "instance_id" {
  value = "${aws_instance.instance.id}"
}

output "bastion_ssh_user" {
  value = "${module.bastion-host.ssh_user}"
}

output "bastion_sg_id" {
  value = "${module.bastion-host.ssh_user}"
}


output "public_ip" {
  value = "${aws_instance.instance.public_ip}"
}

output "bastion_sg" {
  value = "${module.bastion-host.security_group_id}"
}

resource "aws_key_pair" "infra-key" {
  key_name   = "infra-${var.ENV}-key"
  public_key = "${file("${path.root}/${var.PATH_TO_PUBLIC_KEY}")}"
}
