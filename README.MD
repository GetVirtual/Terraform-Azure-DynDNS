## Description ##

This terraform template deploys the following services:
- Azure DNS Zone
- Azure Function & App Service Plan
- Azure Storage Account (for the Azure Function)
- Service Principal within your AzureAD to allow the function app to modify the DNS Zone

## Requirements ##
- Terraform     https://www.terraform.io/downloads.html
- Azure CLI     https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

## First-time setup ##
terraform init
Set variables to your environment in variables.tf

## Variables ##
Azure Subscription ID
Azure Ressource Group Name
Azure Region
DNS Zonename
DNS A-Record
Azure Tenant ID

## Usage ##
az login
terraform plan
terraform apply