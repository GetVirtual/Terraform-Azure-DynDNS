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

## Versions ##
* tf 0.12.28
* azure provider 2.16.0 (pinned)
* azuread 0.10.0

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
* DNS A-Record (default: home)
* Azure Tenant ID

## Usage ##

Deploy it with terraform to your Azure subscription.
~~~~
az login
terraform plan
terraform apply
~~~~

After the successful deployment with terraform the function app will fetch the source code from github and deploy it. 
This will take some minutes and will be finished when you see the "UpdateDNS" function.

Get the Function URL - it will look like this: https://functionURL/api/UpdateDns?code=authcodeforfunction&ip=valueforIP
Now you can update your arecord.dnszonename when you call the function and transmit an ip adress.
