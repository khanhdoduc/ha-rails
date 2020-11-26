variable "VPC_ID" {}

variable "ENV" {}

variable "SOURCE_SG" {}

resource "aws_security_group" "elb-securitygroup" {
  vpc_id      = "${var.VPC_ID}"
  name        = "infra-${var.ENV}-elb"
  description = "security group for load balancer"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "elb"
  }
}

# resource "aws_security_group_rule" "allow-ssh" {
#   type            = "ingress"
#   from_port       = 22
#   to_port         = 22
#   protocol        = "tcp"
#   security_group_id = "${aws_security_group.web-dmz.id}"
#   source_security_group_id = "${var.SOURCE_SG}" 
# }
 
resource "aws_security_group" "web-dmz" {
  vpc_id      = "${var.VPC_ID}"
  name        = "infra-${var.ENV}-web-dmz"
  description = "security group that allows http and all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.elb-securitygroup.id}"]
  }

   ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${var.SOURCE_SG}"]
  }

  tags {
    Name         = "web-dmz"
    Terraform    = "true"
    Environmnent = "${var.ENV}"
  }
}

resource "aws_security_group" "rds-launch" {
  vpc_id      = "${var.VPC_ID}"
  name        = "infra-${var.ENV}-rds-launch"
  description = "security group that allows all egress traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web-dmz.id}", "${var.SOURCE_SG}"]
  }

  tags {
    Name         = "rds-launch"
    Terraform    = "true"
    Environmnent = "${var.ENV}"
  }
}

output "web_dmz_id" {
  value = "${aws_security_group.web-dmz.id}"
}

output "rds_launch_id" {
  value = "${aws_security_group.rds-launch.id}"
}

output "elb_id" {
  value = "${aws_security_group.elb-securitygroup.id}"
}
