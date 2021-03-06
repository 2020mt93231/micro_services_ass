variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "ap-south-1"
}

variable "ec2_user" {
  default = "ubuntu"
}

variable "trender" {
  default = "Automation"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "conn_timeout" {
	default = "4m"
}

variable "vpc_id" {
  default = "vpc-2ef32e45"
}

variable "subnet_id" {
  default = "subnet-fb97bfb7"
}

variable "security_grp_id" {
  default = "sg-0dcf985c31f6d7e54"
}

variable "instance_profile" {
	default = "automation_user"
}

variable "key_name" {
  default = "ec2_key"
}

variable "priv_key" {}

variable "cwd" {}


