locals {
  zones = slice(data.aws_availability_zones.my_zones.names, 3, 5)
}