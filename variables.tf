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

variable "subnets" {
  type = list(object({
    subnet_name = string
    address_prefix = string
  }
  )
  )
}

variable "dns_servers" {
  type = list(string)
}

variable "admin_password" {
  type = string
}