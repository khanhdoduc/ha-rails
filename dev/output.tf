output "s3_public_key_bucket" {
  value = "${module.s3.bastion_bucket_name}"
}

output "s3_media_key_bucket" {
  value = "${module.s3.s3_media_bucket}"
}

output "rds_dns_name" {
  value = "${module.mysql-rds.rds_dns_name}"
}

output "bastion_ssh_user" {
  value = "${module.linux2ami-instance.bastion_ssh_user}"
}

output "railsapp_public_ip" {
  value = "${module.linux2ami-instance.public_ip}"
}

output "bastion_sg" {
  value = "${module.linux2ami-instance.bastion_sg}"
}

output "alb_dns_name" {
  value = "${module.alb.alb_dns_name}"
}