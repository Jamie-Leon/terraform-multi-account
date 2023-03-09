variable "iam_role_name" {
  description = "Role that Terraform uses"
  default     = "TerraformUser"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "eu-west-2"
}

variable "vpc" {
  default = 0
}

variable "vpc_cidr" {
  default = ""
}

variable "public_subnet_ranges" {
  default = []
}

variable "bucket" {
  type    = bool
  default = false
}

variable "dynamodb_table" {
  type    = bool
  default = false
}