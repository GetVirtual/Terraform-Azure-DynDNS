# Terraform Template "Azure DynDNS"
# Deploys: AzureDNS, AzureFunction, StorageAccount, ServicePrincipal
provider "azurerm" {
  version = "=1.22.1"
  subscription_id = "${var.subscriptionid}"
}

provider "azuread" {
  version = "=0.1.0"
}

resource "random_string" "randomstring" {
  length  = 8
  special = false
  lower   = true
  upper   = false
}

resource "random_string" "password" {
  length = 24
  special = true
}

# Create Ressource Group
resource "azurerm_resource_group" "rg" {
  name      = "${var.resourcegroupname}"
  location  = "${var.region}"
}


# Create (Public) DNS Zone
resource "azurerm_dns_zone" "dnszone" {
  name                = "${var.domainname}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  zone_type           = "Public"
}

resource "azurerm_dns_a_record" "dnsrecord" {
  name                = "${var.arecord}"
  zone_name           = "${azurerm_dns_zone.dnszone.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  ttl                 = 300
  records             = ["0.0.0.0"]
}

resource "azurerm_storage_account" "sa" {
  name                     = "sadyndns${random_string.randomstring.result}"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azuread_application" "app" {
  name     = "DynDNS-${random_string.randomstring.result}"
  homepage = "https://DynDNS-${random_string.randomstring.result}"
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azuread_service_principal" "sp" {
  application_id = "${azuread_application.app.application_id}"
}

resource "azuread_service_principal_password" "spsecret" {
  service_principal_id = "${azuread_service_principal.sp.id}"
  value                = "${random_string.password.result}"
  end_date             = "2030-01-01T01:02:03Z"
}

resource "azurerm_role_assignment" "roleassign" {
  scope                 = "${azurerm_dns_zone.dnszone.id}"
  role_definition_name  = "DNS Zone Contributor"
  principal_id          = "${azuread_service_principal.sp.id}"
}

resource "azurerm_app_service_plan" "serviceplan" {
  name                = "app-serviceplan-dyndns"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "function" {
  name                      = "function-dyndns-${random_string.randomstring.result}"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  app_service_plan_id       = "${azurerm_app_service_plan.serviceplan.id}"
  storage_connection_string = "${azurerm_storage_account.sa.primary_connection_string}"
  version                   = "~2"

  app_settings {
    TenantId                  = "${var.tenantid}"
    AppId                     = "${azuread_application.app.application_id}"
    AppSecret                 = "${azuread_service_principal_password.spsecret.value}"
    SubscriptionId            = "${var.subscriptionid}" 
    ResourceGroupName         = "${var.resourcegroupname}"
    ZoneName                  = "${var.domainname}"
    RecordSetName             = "${var.arecord}"
    }
  

  provisioner "local-exec" {
    command     = "az account set --subscription ${subscriptionid}"
  }

  provisioner "local-exec" {
    command     = "az functionapp deployment source config --name ${azurerm_function_app.function.name} --repo-url https://github.com/teilmeier/azure-functions-dyndns --resource-group ${var.resourcegroupname} --manual-integration"
  }
}

