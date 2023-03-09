# Configuring the main account AWS provider
provider "aws" {
  alias  = "primary"
  region = var.aws_region
}

# Look up environment account using main account provider
data "aws_organizations_organization" "org" {
  provider = aws.primary
}

# Retrieve the caller identity to append it to the assume role session name.
data "aws_caller_identity" "current" {
  provider = aws.primary
}

locals {
  # Set environment account ID as local value based on selected Terraform 
  # workspace.
  account_id = data.aws_organizations_organization.org.accounts[
    index(data.aws_organizations_organization.org.accounts.*.name, terraform.workspace)
  ].id

  # Sets the role to assume based on the calling identity, if it is a user, 
  # default to read-only, otherwise use the role passed by the environment
  # variable (this should only be the CI runner).
  iam_role_name = var.iam_role_name
}

provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn     = "arn:aws:iam::${local.account_id}:role/${local.iam_role_name}"
    session_name = "dev-account-from-main-${local.iam_role_name}"
  }
}