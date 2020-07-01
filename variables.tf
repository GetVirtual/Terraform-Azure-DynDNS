# Subscription ID
variable "subscriptionid" {

}

# Tenant ID
variable "tenantid" { 

}

# Ressource Group Name
variable "resourcegroupname" {
    default = "DynDNS"
}

# Azure Region
variable "region" {
    default = "West Europe"
}

# AzureDNS Domain Name
variable "domainname" {
    
}

# AzureDNS A Record
variable "arecord" {
    default = "home"
}

