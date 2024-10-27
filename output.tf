output "primary_vault_id" {
    value       = module.primary_vault_id
    description = "Backup Vault ID from primary region"
}

output "primary_vault_arn" {
    value       = module.primary_vault_arn
    description = "Backup Vault ARN from primary region"
}

# output "secondary_region_vault_id" {
#     value       = module.secondary_region_vault_id
#     description = "Backup Vault ID from secondary region"
# }

# output "secondary_region_vault_arn" {
#     value       = module.secondary_region_vault_arn
#     description = "Backup Vault ARN from secondary region"
# }

# output "secondary_account_primary_region_vault_id" {
#     value       = module.secondary_account_primary_region_vault_id
#     description = "Backup Vault ID from Backup account in primary region"
# }

# output "secondary_account_primary_region_vault_arn" {
#     value       = module.secondary_account_primary_region_vault_arn
#     description = "Backup Vault ARN from Backup account in primary region"
# }

output "backup_plan_arn" {
  value       = module.backup_plan_arn
  description = "Backup Plan ARN"
}

output "backup_selection_id" {
  value       = module.backup_selection_id
  description = "Backup Selection ID"
}