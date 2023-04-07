# all variable are defined externally using `export TF_VAR_project_name=...` in the make.sh file
variable "project_name" {
  default = "ExodusPoint"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "postgres_username" {
  default = "acdba"
}

variable "postgres_password" {
  default = "welcome"
}


variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "172.22.0.0/16"
}