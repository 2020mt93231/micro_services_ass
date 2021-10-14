resource "aws_instance" "scalable_host" {
	ami                         = "ami-0c1a7f89451184c8b"
	instance_type               = var.instance_type
	key_name                    = var.key_name
	associate_public_ip_address = "true"

	subnet_id = var.subnet_id
    security_groups = [var.security_grp_id]


	tags = {
		Name           = "ubuntu"
		"Trender"      = var.trender
		"ValidUntil"   = formatdate("YYYY-MM-DD", timeadd(timestamp(), "24h"))
		"workingHours" = "IGNORE"
	}

	connection {
			type = "ssh"
			host     = aws_instance.scalable_host.public_ip
			timeout  = var.conn_timeout
			user     = var.ec2_user
			private_key = file(var.private_key)
	}

	provisioner "file" {
    	source      = var.cwd
    	destination = var.private_key
  	}
}

output "hostname" {
		value = aws_instance.scalable_host.public_ip
}
