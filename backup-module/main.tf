#1. Create vault and lock for the Primary Region

# Create AWS Backup Vault in Prod Account Primary Region (for storing backups)
resource "aws_backup_vault" "primary_region_vault" {
    provider      = aws.prod_primary_region
    name          = "primary-vault"
    kms_key_arn   = var.vault_key_arn
}

# Enable Vault Lock for WORM protection
resource "aws_backup_vault_lock_configuration" "primary_region_vault_lock" {
    provider      = aws.prod_primary_region
    backup_vault_name = aws_backup_vault.primary_region_vault.name
    min_retention_days = var.minRetentionLock  # Define your WORM protection retention (days)
    max_retention_days = var.maxRetentionLock  # Example for 10 years retention
}

# ###############################################################################################
# If the Vaults are not created already uncomment below code to create vaults and locks

# # Create AWS Backup Vault in Prod Account Secondary Region (for storing copies of backups)
# resource "aws_backup_vault" "secondary_region_vault" {
#     provider      = aws.prod_secondary_region
#     name          = "secondary_region_vault"
#     kms_key_arn   = var.vault_key_arn
# }

# # Enable Vault Lock for WORM protection
# resource "aws_backup_vault_lock_configuration" "secondary_region_vault_lock" {
#     provider = aws.prod_secondary_region
#     backup_vault_name = aws_backup_vault.secondary_region_vault.name
#     min_retention_days = var.minRetentionLock  # Define your WORM protection retention (days)
#     max_retention_days = var.maxRetentionLock  # Example for 10 years retention
# }

# # Create AWS Backup Vault in Prod Account Primary Region (for storing backups)
# resource "aws_backup_vault" "secondary_account_primary_region_vault" {
#     provider      = aws.secondary_account_primary_region
#     name          = "secondary_account_primary_region_vault"
#     kms_key_arn   = var.vault_key_arn
# }

# # Enable Vault Lock for WORM protection
# resource "aws_backup_vault_lock_configuration" "secondary_account_primary_region_vault_lock" {
#     provider = aws.secondary_account_primary_region
#     backup_vault_name = aws_backup_vault.secondary_account_primary_region_vault.name
#     min_retention_days = var.minRetentionLock  # Define your WORM protection retention (days)
#     max_retention_days = var.maxRetentionLock  # Example for 10 years retention
# }

###############################################################################################

# 2. define backup plan

# Enables the x-account backup 
resource "aws_backup_global_settings" "backup_global_settings" {
  global_settings = {
    "isCrossAccountBackupEnabled" = "true"
  }
}

# Backup Plan definition (frequency and retention settings)
resource "aws_backup_plan" "backup_plan" {
    name = "backup-plan"

    # Rule for regular backups
    rule {
        rule_name           = "regular-backup"
        target_vault_name   = aws_backup_vault.primary_region_vault.name
        schedule            = var.backup_Frequency 
        lifecycle {
            delete_after    = var.backup_Retention    
        }
    }

    # Rule for copy actions with a different schedule
    rule {
        rule_name           = "copy-rule"
        target_vault_name   = aws_backup_vault.primary_region_vault.name
        schedule            = var.backup_copy_Frequency 
        lifecycle {
            delete_after    = var.backup_Retention    
        }
  
      # Enable cross-region copy
        copy_action {
            destination_vault_arn = var.secondary_region_vault_arn         #Variable with fixed ARN exists but if it doesn't already exist there is part of the code commented to create the vault and lock
            lifecycle {
                delete_after = var.backup_copy_Retention  
            }
        }
  
      # Enable cross-account copy
        copy_action {
            destination_vault_arn = var.secondary_account_vault_arn        #Variable with fixed ARN exists but if it doesn't already exist there is part of the code commented to create the vault and lock
            lifecycle {
                delete_after = var.backup_copy_Retention
            }
        }
    }
}

# 3. Define backup selection

# Resource Selection (Tag-based)
resource "aws_backup_selection" "backup_selection" {
    iam_role_arn    = aws_iam_role.iam_backup_role.arn
    name            = "backup-selection"
    plan_id  = aws_backup_plan.backup_plan.id

    dynamic "selection_tag" {
        for_each = var.selection_tags
        content {
            type  = selection_tag.value["type"]
            key   = selection_tag.value["key"]
            value = selection_tag.value["value"]
        }
    }

}

# 4. IAM Roles and policies

data "aws_iam_policy_document" "assume_role" {
    statement {
        effect = "Allow"

        principals {
            type        = "Service"
            identifiers = ["backup.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
    }
}
resource "aws_iam_role" "iam_backup_role" {
    name               = "iam_backup_role"
    assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "iam_backup_role_policy_attachment" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
    role       = aws_iam_role.iam_backup_role.name
}

