variable "location" {
  type    = string
  default = "eastus2"
}

variable "projectName" {
  type    = string
  default = "devteam"
}

variable "env" {
  type    = string
  default = "np"
}

variable "nsg_name" {
  type    = string
  default = "primary_nsg"
}

variable "cidr_range" {
  type    = string
}