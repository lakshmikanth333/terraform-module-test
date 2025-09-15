resource "aws_vpc" "main" {
  cidr_block = var.main_cidr
  tags = merge(var.common_tags,
  {
    Name = "main_vpc"
  }
  )
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags,
  {
    Name = "main_igw"
  }
  )
}



resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr)
  cidr_block = var.public_subnet_cidr[count.index]
  vpc_id = aws_vpc.main.id
  availability_zone = local.zones[count.index]
  tags = merge(
    var.common_tags,
    {
      Name = "${var.public_subnet_names[count.index]}-${local.zones[count.index]}"
    }
  )

}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr)
  cidr_block = var.private_subnet_cidr[count.index]
  vpc_id = aws_vpc.main.id
  availability_zone = local.zones[count.index]
  tags = merge(
    var.common_tags,
    {
      Name = "${var.private_subnet_names[count.index]}-${local.zones[count.index]}"
    }
  )

}

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  cidr_block = var.database_subnet_cidr[count.index]
  vpc_id = aws_vpc.main.id
  availability_zone = local.zones[count.index]
  tags = merge(
    var.common_tags,
    {
      Name = "${var.database_subnet_names[count.index]}-${local.zones[count.index]}"
    }
  )
}

# NAT Gateway

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "my_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[1].id

  tags = merge(var.common_tags, var.nat_gateway_tags,
  {
    Name = "main_nat"
  }
  )

  depends_on = [aws_internet_gateway.main_igw]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags, var.public_route_table_tags, 
  {
  Name = "public_route_table"
}
)
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags, var.private_route_table_tags, 
  {
  Name = "private_route_table"
}
)
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags, var.database_route_table_tags,
  {
  Name = "database_route_table"
}
)
}

resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_igw.id

}

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.my_nat.id
}

resource "aws_route" "database_route" {
  route_table_id            = aws_route_table.database_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.my_nat.id
}

resource "aws_route_table_association" "public_association" {
  count = length(var.public_subnet_cidr)
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "private_association" {
  count = length(var.private_subnet_cidr)
  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "database_association" {
  count = length(var.database_subnet_cidr)
  subnet_id = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database_route_table.id
}

































































