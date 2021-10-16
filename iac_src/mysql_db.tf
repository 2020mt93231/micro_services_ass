resource "aws_db_instance" "mysql_db" {
    identifier = "mysqldatabase"
    storage_type = "gp2"
    allocated_storage    = 10

    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t2.micro"
    port                 = "3306"
    # name of the db subnet group
    db_subnet_group_name = "default"

    name                 = "mydb"
    username             = var.db_user
    password             = var.db_pwd

    parameter_group_name = "default.mysql8.0"
    availability_zone    = var.region
    publicly_accessible  = true
    deletion_protection  = false
    skip_final_snapshot  = false

	tags = {
		Name           = "Mysql_db_instance"
		"Trender"      = var.trender
		"ValidUntil"   = formatdate("YYYY-MM-DD", timeadd(timestamp(), "24h"))
		"workingHours" = "IGNORE"
	}
}

