terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "=3.24.0"
    }
  }
}

provider "azurerm" {
  features {}
}



data "azurerm_billing_mca_account_scope" "acc" {
  billing_account_name = "e879cf0f-2b4d-5431-1"   // Provide your billing account name
  billing_profile_name = "PE2Q-NOIT-BG7-TGB"     //Provide your billing profile name
  invoice_section_name = "MTT4-OBS7-PJA-TGB"    //Provide your invoice section name
}

resource "azurerm_subscription" "sub" {
  subscription_name = "My Example MCA Subscription"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.acc .id
}

provider "azurerm" {
  alias   = "sub"
  subscription_id = azurerm_subscription.sub.id
  client_id       = "Application_id"    //  you need to provide the application id here
  client_secret   = "Client_Secret"    // You need to provide the client secret here
  tenant_id       = "Your_tenant_id"   //You need to provide the tenant id here
  features {}
}



resource "azurerm_role_assignment" "role" {
  provider =             azurerm.sub
  scope                = azurerm_subscription.sub.id
  role_definition_name = "Contributor"
  principal_id         =  var.application_id
}

resource "azurerm_resource_group" "RG" {
  provider = azurerm.sub
  location = "Rg-location"
  name     = "Rg-Name"
}