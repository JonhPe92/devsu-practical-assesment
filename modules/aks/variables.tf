variable "location" {

}
variable "resource_prefix" {
  type = string
  
}
variable "environment" {
  type = string
}
variable "nodes_count" {
    type = number
    default = 1
}

variable "service_principal_name" {
  type = string
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "client_id" {}
variable "client_secret" {
  type = string
  sensitive = true
}