variable "rg_name" {}
variable "location" {}
variable "lb_name" {}
variable "backend_nics" {
  type = map(string)
}