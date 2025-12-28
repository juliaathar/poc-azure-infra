terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.0.2"
    }
  }
  required_version = ">= 1.1.0"
}

provider azurerm {
    features {

    }
}

resource "azurerm_resource_group" "rg" {
  name = "${var.group_name}-ResourceGroup"
  location = "eastus2"
}

resource "azurerm_api_management" "apim" {
  name = "${var.group_name}-ApiManagement"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name = "Consumption_0"
  publisher_email = "${var.publisher_email}"
  publisher_name = "${var.publisher_name}"
}

resource "azurerm_storage_account" "storage" {
  name = "juliatestedasilva"
  location = azurerm_resource_group.rg.location
  account_replication_type = "LRS"
  account_tier = "Standard"
  resource_group_name = azurerm_resource_group.rg.name  
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name = "${var.group_name}-AppServicePlan"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "function" {
  name = "${var.group_name}-TestFunction"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  storage_account_name = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  os_type = "linux"
}