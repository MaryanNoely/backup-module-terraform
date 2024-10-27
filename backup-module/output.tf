output "primary_vault_id" {
    value       = aws_backup_vault.primary_vault.id
    description = "Backup Vault ID from primary region"
}

output "primary_vault_arn" {
    value       = aws_backup_vault.primary_vault.arn
    description = "Backup Vault ARN from primary region"
}

# output "secondary_region_vault_id" {
#     value       = aws_backup_vault.secondary_region_vault.id
#     description = "Backup Vault ID from secondary region"
# }

# output "secondary_region_vault_arn" {
#     value       = aws_backup_vault.secondary_region_vault.arn
#     description = "Backup Vault ARN from secondary region"
# }

# output "secondary_account_primary_region_vault_id" {
#     value       = aws_backup_vault.secondary_account_primary_region_vault.id
#     description = "Backup Vault ID from Backup account in primary region"
# }

# output "secondary_account_primary_region_vault_arn" {
#     value       = aws_backup_vault.secondary_account_primary_region_vault.arn
#     description = "Backup Vault ARN from Backup account in primary region"
# }

output "backup_plan_arn" {
  value       = aws_backup_plan.backup_plan.arn
  description = "Backup Plan ARN"
}

output "backup_selection_id" {
  value       = aws_backup_selection.backup_selection.id
  description = "Backup Selection ID"
}