# Subscription ID
variable "subscriptionid" {
    description = "Please enter your existing subscription ID:"
}

variable "tenantid" {
    description = "Please enter your existing Azure AD tenant ID:"
}

# Ressource Group Name
    description = "Please enter the name for the Ressource Group"
}

# Azure Region
variable "region" {
    description = "Please enter the Azure Region to be used (e.g. West Europe)"
}

# AzureDNS Domain Name
variable "domainname" {
    description = "Please enter the domain name you own (e.g. yourdomain.com)"
}

# AzureDNS A Record
variable "arecord" {
    description = "Please enter the a-record you want to use (e.g. home)"
}

