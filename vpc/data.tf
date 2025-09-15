data "aws_availability_zones" "my_zones" {
    state = "available"
}

output "my_az" {
  value = data.aws_availability_zones.my_zones
}