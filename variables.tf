variable "environment" {
  type        = string
  description = "enviroment deployment name"
}

variable "resource_prefix" {
  type = string
  default = "devsu"
  
}
variable "location" {
  type    = string
  default = "eastus"
}

variable "service_principal_name" {
  type = string
}

variable "subscriptions_ten_id" {
  type = string
}

variable "keyvault_name" {
  type = string
}

variable "nodes_count" {
  type = number
}