resource "aws_instance" "scalable_host" {
	ami                         = "ami-0c1a7f89451184c8b"
	instance_type               = var.instance_type
	key_name                    = var.key_name
	associate_public_ip_address = "true"

	subnet_id = var.subnet_id
    security_groups = [var.security_grp_id]
	iam_instance_profile = var.instance_profile

	tags = {
		Name           = "ubuntu"
		"Trender"      = var.trender
		"ValidUntil"   = formatdate("YYYY-MM-DD", timeadd(timestamp(), "24h"))
		"workingHours" = "IGNORE"
	}

	connection {
			host        = aws_instance.scalable_host.public_ip
			type 	    = "ssh"
			timeout     = var.conn_timeout
			user        = var.ec2_user
			private_key = file(var.priv_key)
	}

	provisioner "file" {
    	source      = var.cwd
    	destination = "/tmp/src"
  	}

	provisioner "remote-exec" {
		inline = [
			"chmod +x /tmp/src/install_sql_workbench.sh",
			"sudo /bin/bash /tmp/src/install_sql_workbench.sh"
#			,"chmod +x /tmp/src/install_kubernetes.sh",
#			"sudo /bin/bash /tmp/src/install_kubernetes.sh"
		]
	}
}

output "ip" {
	value = aws_instance.scalable_host.public_ip
}