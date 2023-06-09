terraform {
  /*   backend "s3" {
    bucket         = "terraform-multi-account"
    key            = "terraform-environments-state-file/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "TerraformMainStateLock"
    kms_key_id     = "alias/s3" # Optionally change this to the custom KMS alias you created - "alias/terraform"
  } */

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.33"
    }
  }

  required_version = "= 1.4.4"
}