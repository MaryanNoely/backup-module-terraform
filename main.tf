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

# # Create AWS Backup Vault in Prod Account Primary Region (for storing backups)
# resource "aws_backup_vault" "prodPrimary" {
#   name          = "backup-vault"
#   kms_key_arn   = aws_kms_key.backup_vault_key.arn
#   tags = {
#     Name = "ProdPrimaryBackupVault"
#     Environment = "Prod"
#   }
# }



# # Create AWS Backup Vault in Prod Account Primary Region (for storing backups)
# resource "aws_backup_vault" "prodSecondary" {
#   name          = "backup-vault"
#   kms_key_arn   = aws_kms_key.backup_vault_key.arn
#   tags = {
#     Name = "ProdSecondaryBackupVault"
#     Environment = "Prod"
#   }
# }




# # Enable Vault Lock for WORM protection
# resource "aws_backup_vault_lock_configuration" "example" {
#   backup_vault_name = aws_backup_vault.example.name
#   min_retention_days = 30    # Define your WORM protection retention (days)
#   max_retention_days = 3650  # Example for 10 years retention
# }

# # Backup Plan definition (frequency and retention settings)
# resource "aws_backup_plan" "example" {
#   name = "my-backup-plan"

#   rule {
#     rule_name         = "daily-backup"
#     target_vault_name = aws_backup_vault.prodPrimary.name
#     schedule          = var.backupFrequency 
#     lifecycle {
#       delete_after          = var.backupProdPrimaryRetention    # Retain backups for 90 days
#       cold_storage_after    = var.backupToCold  # Move to cold storage after 30 days
#     }

#     # Enable cross-region copy
#     copy_action {
#       destination_vault_arn = aws_backup_vault.prodSecondary.name
#       lifecycle {
#         delete_after = var.backupProdSecondaryRetention  # Retain cross-region copies for 180 days
#       }
#     }

#     # Enable cross-account copy
#     copy_action {
#       destination_vault_arn = "arn:aws:backup:eu-central-1:BACKUP_ACCOUNT_ID:backup-vault:backup-frankfurt-backup-vault"
#       lifecycle {
#         delete_after = 180  # Retain cross-account copies for 180 days
#       }
#     }
#   }
# }

# # Resource Selection (Tag-based)
# resource "aws_backup_selection" "example" {
#     iam_role_arn    = aws_iam_role.backup_role.arn
#     name            = "my-backup-selection"
#     plan_id  = aws_backup_plan.example.id

#     selection_tag {
#         type  = "STRINGEQUALS"
#         key   = "ToBackup"
#         value = "True"
#     }
#         selection_tag {
#         type  = "STRINGLIKE"
#         key   = "Owner"
#         value = "owner@eulerhermes.com.com"
#     }

# }

# # IAM role for AWS Backup
# resource "aws_iam_role" "backup_role" {
#   name = "backup-role"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "backup.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# # IAM policy for the backup role to access resources
# resource "aws_iam_role_policy" "backup_policy" {
#   role   = aws_iam_role.backup_role.id
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "rds:CreateDBSnapshot",
#         "rds:DescribeDBInstances",
#         "ec2:DescribeVolumes",
#         "dynamodb:DescribeTable"
#       ],
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }


