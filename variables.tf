variable "name" {
  type = list(string)
}

variable "as_name" {
  type = string
}

variable "location" {
  type = string
  }

variable "rg_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "size" {
  type = string
  default = "Standard_B1ms"
}

variable "admin" {
  type = string
  default = "lnxadmin"
  sensitive = true
}

variable "password" {
  type = string
  sensitive = true
}

variable "os_image" {
  type = map(string)
  default = {}
}

variable "rules" {
  type = any
}
