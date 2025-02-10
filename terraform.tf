/*
The terraform code is to be executed by GH workflow which does az cli login using UMI with apply permissions from ALZ stage
*/

terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0, < 5.0"
    }
  }

  // below information all from previous ESLZ deployment except for key which is new as this should create new tfstate file in same container
  backend "azurerm" {
    resource_group_name  = "rg-test8-pru12-state-southeastasia-001"
    storage_account_name = "stotesprusou001ynml"
    container_name       = "pru12-tfstate"
    key                  = "pru12fw.tfstate"
    subscription_id      = "a66aa8a7-28a9-457b-b879-1cfff0201ed3"
  }
}

// below default provider will use management subscription
provider "azurerm" {
  features {}
  subscription_id = "a66aa8a7-28a9-457b-b879-1cfff0201ed3"
}

// below provider will use connectivity subscription
provider "azurerm" {
  features {}
  alias           = "conn"
  subscription_id = "ff3bfb36-04e0-42d0-a610-525c7620ed41"
}