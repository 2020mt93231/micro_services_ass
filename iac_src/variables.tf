variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "ap-south-1"
}

variable "agent_user" {
  default = "ubuntu"
}

variable "trender" {
  default = "Automation"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "conn_timeout" {
	default = "5m"
}