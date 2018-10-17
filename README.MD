## Authors ##
* Philip Teilmeier: Source code for the Azure Function "magic"
* Jürgen Lobenz:    Terraform Template for deployment

## Description ##

This terraform template deploys the following services:
* Create: Ressource Group
* Create: Azure DNS Zone & A-Record
* Create: App Service Plan & Azure Function
* Create: Azure Storage Account (for the Azure Function)
* Create: Service Principal within your AzureAD 
* Assign the Service Prinicipal the "DNS Zone Contributor" role
* Connect the Azure Function to get the source code from https://github.com/teilmeier/azure-functions-dyndns

## Requirements ##
* Terraform     https://www.terraform.io/downloads.html
* Azure CLI     https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

## First-time setup ##
* Download & install the above requirements
* Clone the repo to your local folder
* Add the terraform executeable to the PATH variable (or copy it to the repo folder)
* Modify variables.tf for the correct values in your environment
~~~~
terraform init
~~~~

## Variables ##
* Azure Subscription ID
* Azure Ressource Group Name
* Azure Region
* DNS Zonename
* DNS A-Record
* Azure Tenant ID

## Usage ##
~~~~
az login
terraform plan
terraform apply
~~~~
