variable "terraformVersion"{
    description = "Default terraform version"
    type = string
    default = "5.25.0"
}

variable "secondary_region_vault_arn"{
    description= "ARN of the Backup Vault in the secondary account for cross-account backup copies"
    type= string
    default="arn:aws:backup:<region>:<secondary_region_id>:backup-vault/<vault_name>"
}

variable "secondary_account_vault_arn"{
    description= "ARN of the Backup Vault in the secondary account for cross-account backup copies"
    type= string
    default="arn:aws:backup:<region>:<secondary_account_id>:backup-vault/<vault_name>"
}

variable "vault_key_arn"{
    description= "Key to encrypt/decrypt backups"
    type= string
}
variable "minRetentionLock" {
    description= "Retention of the vault lock (days)"
    type = number
    default= 2557  # 7 years
}
variable "maxRetentionLock" {
    description= "Retention of the vault lock (days)"
    type = number
    default= 3650 # 10 years
}
variable "backup_Frequency" {
    type= string
    description = <<EOT
        Backup Frequency. 

        Expected a cron string:
        * * * * * *     <command to execute>
        | | | | | |
        | | | | | year
        | | | | day of the week (0–6) (Sunday to Saturday; 
        | | | month (1–12)             7 is also Sunday on some systems)
        | | day of the month (1–31)
        | hour (0–23)
        minute (0–59)

        E.g "cron(0 12 * * ? *)"  => Daily backup at 12 PM UTC 

    EOT 
}
variable "backup_Retention"{
    description= "Reteined up to (days)"
    type= number
}

variable "backup_copy_Frequency" {
    type= string
    description = <<EOT
        Backup Frequency. 

        Expected a cron string:
        * * * * * *     <command to execute>
        | | | | | |
        | | | | | year
        | | | | day of the week (0–6) (Sunday to Saturday; 
        | | | month (1–12)             7 is also Sunday on some systems)
        | | day of the month (1–31)
        | hour (0–23)
        minute (0–59)

        E.g "cron(0 12 * * ? *)"  => Daily backup at 12 PM UTC 

    EOT 
    default = "cron(0 12 * * SUN *)"  #Backup on Sundays at 12 PM UTC 
}

variable "backup_copy_Retention"{
    description= "Reteined the backup copy up to (days)"
    type= number
    default = 180
}

variable "selection_tags" {
    type = list(object({
        type  = string
        key   = string
        value = string
      }))
    description = "An array of tag condition objects used to filter resources based on tags for assigning to a backup plan"
}