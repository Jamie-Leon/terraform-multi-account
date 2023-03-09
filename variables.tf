variable "iam_role_name" {
  description = "Role that Terraform uses"
  default     = "TerraformUser"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "eu-west-2"
}