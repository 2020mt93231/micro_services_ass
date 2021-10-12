resource "aws_instance" "scalable_host" {
	# Amazon Linux 2 AMI
	ami                         = "ami-0c1a7f89451184c8b"
	instance_type               = var.instance_type
	associate_public_ip_address = "true"

	tags = {
		Name           = "ubuntu"
		"Trender"      = var.trender
		"ValidUntil"   = formatdate("YYYY-MM-DD", timeadd(timestamp(), "24h"))
		"workingHours" = "IGNORE"
	}
}