terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
      configuration_aliases = [aws.prod_primary_region, aws.prod_secondary_region, aws.backup_primary_region]
    }
  }
}

provider "aws" {
    profile="default"
    alias = "prod_primary_region"
    region = var.Primary_Region

}

provider "aws" {
    profile="default"
    alias = "prod_secondary_region"
    region = var.Secondary_Region

}

provider "aws" {
    profile="default"
    alias = "secondary_account_primary_region"
    region = var.Primary_Region
    assume_role {
        role_arn = var.Backup_Account_Assume_Role
  }

}

module backup-module { 
  source = "./backup-module"

  #Plan
  backup_Frequency = var.frequency
  backup_Retention = var.retention
  vault_key_arn = "arn:aws:kms:<region>:<account_id>:key/<key_id>"  # Replace with the actual ARN of the KMS key
  #Resource selection
  selection_tags = var.selection_tags

}