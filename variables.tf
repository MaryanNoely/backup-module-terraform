variable "terraformVersion"{
    description = "Default terraform version"
    type = string
    default = "5.25.0"
}
variable "Primary_Region"{
    description= "AWS Primary Region"
    type= string
    default="eu-central-1"
}
variable "Secondary_Region"{
    description= "AWS Secondary Region"
    type= string
    default="eu-west-1"
}
variable "Backup_Account_Assume_Role"{
    description= "AWS Secondary Region"
    type= string
    default="arn:aws:iam::BACKUP_ACCOUNT_ID:role/CrossAccountBackupRole"
}

# Backup module variables
variable frequency{
    type    = string
    default = "cron(0 12 * * ? *)"  # Daily backup at 12 PM UTC
    }
variable retention{
    type    = number
    default = 90
    }
variable "selection_tags" {
    type = list(object({
        type  = string
        key   = string
        value = string
      }))
    default     = [{
        type  = "STRINGEQUALS"
        key   = "ToBackup"
        value = "True"
        },{
        type  = "STRINGLIKE"
        key   = "Owner"
        value = "owner@eulerhermes.com.com"
        }]
}