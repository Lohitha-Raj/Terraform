variable "rg_name" {}
variable "location" {}
variable "subnet_id" {}

variable "vm_names" {
  type = list(string)
}

variable "admin_username" {
  default = "azureuser"
}

variable "admin_password" {
  sensitive = true
}