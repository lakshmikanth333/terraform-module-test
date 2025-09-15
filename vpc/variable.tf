variable "main_cidr" {}

variable "common_tags" {
  default = {}
}

variable "public_subnet_cidr" {}

variable "private_subnet_cidr"  {}

variable "database_subnet_cidr" {}


variable "public_subnet_names" {
  default = ["public-subnet-1", "public-subnet-2"]
}

variable "private_subnet_names" {
  default = ["private-subnet-1", "private-subnet-2"]
}


variable "database_subnet_names" {
  default = ["database-subnet-1", "database-subnet-2"]
}


variable "nat_gateway_tags" {
  default = {}
}

variable "public_route_table_tags" {
  default = {}
}

variable "private_route_table_tags" {
  
  default = {}
}

variable "database_route_table_tags" {
  
  default = {}
}

