resource "aws_s3_bucket" "s3-pixta-infra-bastion-bucket" {
  bucket = "s3-pixta-infra-bastion-bucket"
  acl    = "private"
}
resource "aws_s3_bucket_object" "bastion-public-key" {
  bucket = "${aws_s3_bucket.s3-pixta-infra-bastion-bucket.id}"
  key    = "bastion-key.pub"
  source = "khanh-infra.pub"
}

resource "aws_s3_bucket" "s3-pixta-infra-media-bucket" {
  bucket = "s3-pixta-infra-media-bucket"
  acl    = "private"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::s3-pixta-infra-media-bucket/*"
            ]
        }
    ]
}
EOF
}

output "s3_media_bucket" {
  value = "${aws_s3_bucket.s3-pixta-infra-media-bucket.id}"
}

output "bastion_bucket_name" {
  value = "${aws_s3_bucket.s3-pixta-infra-bastion-bucket.id}"
}
