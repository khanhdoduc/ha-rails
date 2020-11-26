variable "SECURITY_GROUP" {}
variable "ENV" {}
variable "VPC_ID" {}
variable "INSTANCE_IDS" {
  type = "string"
}

variable "PUBLIC_SUBNETS" {
  type = "list"
}

variable "PRIVATE_SUBNETS" {
  type = "list"
}

resource "aws_lb" "infra-alb" {
  name               = "infra-${var.ENV}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.SECURITY_GROUP}"]
  subnets            = ["${var.PUBLIC_SUBNETS}"]

  enable_deletion_protection = false

  #   access_logs {
  #     bucket  = "${aws_s3_bucket.lb_logs.bucket}"
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = {
    Terraform   = "true"
    Environment = "${var.ENV}"
  }
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = "${aws_lb.infra-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.infra-target-group.arn}"
  }
}

resource "aws_lb_target_group" "infra-target-group" {
  name     = "infra-${var.ENV}-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.VPC_ID}"

  health_check = {
    enabled  = true
    protocol = "HTTP"
    path     = "/"
    port     = "traffic-port"

    healthy_threshold   = "2"
    unhealthy_threshold = "3"
    timeout             = "5"
    interval            = "6"
    matcher             = "200"
  }

  tags = {
    Terraform   = "true"
    Environment = "${var.ENV}"
  }
}

resource "aws_lb_target_group_attachment" "infra-target-group-attachment" {
  target_group_arn = "${aws_lb_target_group.infra-target-group.arn}"
  target_id        = "${var.INSTANCE_IDS}"
  port             = 80
}


output "target_group_arn" {
  value = "${aws_lb_target_group.infra-target-group.arn}"
}

output "alb_dns_name" {
  value = "${aws_lb.infra-alb.dns_name}"
}
