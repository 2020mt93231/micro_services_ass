resource "aws_instance" "scalable_host" {
	ami                         = "ami-0c1a7f89451184c8b"
	instance_type               = var.instance_type
	key_name                    = var.key_name
	associate_public_ip_address = "true"

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
			private_key = file(format("key/", var.key_name, ".pem"))
	}

	provisioner "file" {
    	source      = "key"
    	destination = "/tmp/key"
  	}
}

output "hostname" {
		value = aws_instance.scalable_host.public_ip
}