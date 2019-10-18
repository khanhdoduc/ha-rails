resource "aws_launch_configuration" "as-launchconfig" {
  name_prefix          = "as-launchconfig"
  image_id             = "${var.AMI}"
  instance_type        = "${var.INSTANCE_TYPE}"
  key_name             = "${aws_key_pair.infra-key.key_name}"
  security_groups      = ["${var.SECURITY_GROUP}"]
  # user_data            = "${var.USER_DATA_FOR_SCALE}"
  iam_instance_profile = "${aws_iam_instance_profile.s3-infra-all-role-instanceprofile.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "as-group" {
  name                      = "as-group"
  vpc_zone_identifier       = ["${var.PRIVATE_SUBNETS}"]
  launch_configuration      = "${aws_launch_configuration.as-launchconfig.name}"
  min_size                  = 0
  max_size                  = 1
  health_check_grace_period = 60
  health_check_type         = "ELB"
  target_group_arns         = ["${var.TARGET_GROUP_ARN}"]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "linux2ami-autoscale-instance"
    propagate_at_launch = true
  }
}
