resource "aws_iam_role" "s3-infra-all-role" {
  name = "s3-infra-${var.ENV}-all-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "s3-infra-readonly-role" {
  name = "s3-infra-${var.ENV}-readonly-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3-infra-all-policy" {
  name = "s3-infra-${var.ENV}-all-policy"
  role = "${aws_iam_role.s3-infra-all-role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "s3-infra-readonly-policy" {
  name = "s3-infra-${var.ENV}-readonly-policy"
  role = "${aws_iam_role.s3-infra-readonly-role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1425916919000",
            "Effect": "Allow",
            "Action": [
                "s3:List*",
                "s3:Get*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "s3-infra-all-role-instanceprofile" {
  name = "s3-infra-${var.ENV}-all-role-instanceprofile"
  role = "${aws_iam_role.s3-infra-all-role.name}"
}

resource "aws_iam_instance_profile" "s3-infra-readonly-role-instanceprofile" {
  name = "s3-infra-${var.ENV}-readonly-role-instanceprofile"
  role = "${aws_iam_role.s3-infra-readonly-role.name}"
}



