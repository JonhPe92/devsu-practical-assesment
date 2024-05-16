terraform {

  required_providers {
    azuread = "~> 2.48.0"
    random  = "~> 3.1"
    azurerm = "~> 3.100.0"
    helm = ">= 2.1.0"
    kubernetes = "~> 2.30.0"
  }
}