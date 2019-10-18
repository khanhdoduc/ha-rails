variable "PRIVATE_SUBNETS" {
  type = "list"
}
variable "RDS_PASSWORD" {}
variable "SECURITY_GROUP" {}
variable "ENV" {}
 
resource "aws_db_subnet_group" "mysql-subnet" {
  name        = "mysql-subnet"
  description = "RDS subnet group"
  subnet_ids  = ["${var.PRIVATE_SUBNETS}"]
}

resource "aws_db_parameter_group" "mysql-parameters" {
  name        = "mysql-parameters"
  family      = "mysql5.7"
  description = "MySQL parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
} 

resource "aws_db_instance" "mysql" {
  allocated_storage       = 20                                                # 20 GB of storage, gives us more IOPS than a lower number
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"                                    
  identifier              = "mysql"
  name                    = "mydb"
  port                    = 3306                                              # port accept connection
  username                = "root"                                            # username
  password                = "${var.RDS_PASSWORD}"                             # password
  vpc_security_group_ids  = ["${var.SECURITY_GROUP}"]
  db_subnet_group_name    = "${aws_db_subnet_group.mysql-subnet.name}"
  publicly_accessible     = false                                             # db instance will not have a public IP address assigned
  parameter_group_name    = "${aws_db_parameter_group.mysql-parameters.name}"
  multi_az                = "true"                                            # set to true to have high availability: 2 instances synchronized with each other
  storage_type            = "gp2"
  backup_retention_period = 7                                                 # how long you’re going to keep your backups

  # availability_zone = "${aws_subnet.main-private-1.availability_zone}"      # prefered AZ
  skip_final_snapshot = true # skip final snapshot when doing terraform destroy

  tags {
    Name         = "mysql-instance"
    Terraform    = "true"
    Environmnent = "${var.ENV}"
  }
}

output "rds_dns_name" {
  value = "${aws_db_instance.mysql.address}"
}

