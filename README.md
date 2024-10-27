# backup-module-terraform
A module that configures a backup policy, with cross-region and cross-account copies.
Note: This excercise is part of a challenge and it is not production ready


Challenge: Scenario #4

Context
A new requirement dictates to implement a cloud backup policy on AWS using
AWS Backup service, automation is key when it comes to deploying at a scale
the backup policy, cloudfoundation team came up with a design validated by
security, compliance and architecture team illustrated underneath

Scope
Based on the inputs variables, perform backup in Prod Frankfurt and copy it x-region to Ireland vault and x-account to Backup account in Frankfurt region, assuming they exists already.
There is code commented to create it if not.

External Input Variables:
    Plan definition:
        Frequency 
        Retention 
        Encryption Key 
    Resource Selection:
        Condition tags
Outputs
    Vault ID and ARN
    Backup Plan ARN
    Backup Selection ID

Tasks
1. Create vault and lock for the Primary Region
2. Define backup plan
3. Define backup selection
4. IAM Roles and policies

