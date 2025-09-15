module "main_vpc" {
  source               = "../zvpc"
  main_cidr            = var.main_cidr
  common_tags          = var.common_tags
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  database_subnet_cidr = var.database_subnet_cidr
}

variable "main_cidr" {
  default = "10.0.0.0/16"
}

variable "common_tags" {
  default = {
    project  = "etrade"
    provider = "aws"
  }
}

variable "nat_gateway_tags" {
  default = {
    nat = "yes"
  }
}

variable "public_subnet_cidr" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "private_subnet_cidr" {
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "database_subnet_cidr" {
  default = ["10.0.3.0/24", "10.0.33.0/24"]
}



