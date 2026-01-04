# Public Route Table: Routes traffic from public subnets (e.g., ALB) to the Internet Gateway
resource "aws_route_table" "public-rt-01" {
  vpc_id = aws_vpc.vpc-01.id

  # IPv4 default route to Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-01.id
  }

  tags = {
    Name = "public-rt-01"
  }
}
# Public Route Table: Routes traffic from public subnets (e.g., ALB) to the Internet Gateway
resource "aws_route_table" "public-rt-02" {
  vpc_id = aws_vpc.vpc-01.id

  # IPv4 default route to Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-01.id
  }

  tags = {
    Name = "public-rt-02"
  }
}

# Private Route Table 1: Routes traffic from private subnet 1 through NAT Gateway 1
resource "aws_route_table" "private-rt-01" {
  vpc_id = aws_vpc.vpc-01.id

  # IPv4 default route to NAT Gateway 1
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-1.id
  }

  tags = {
    Name = "private-rt-01"
  }
}

# Private Route Table 2: Routes traffic from private subnet 2 through NAT Gateway 2
resource "aws_route_table" "private-rt-02" {
  vpc_id = aws_vpc.vpc-01.id

  # IPv4 default route to NAT Gateway 2
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-2.id
  }

  tags = {
    Name = "private-rt-02"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public-rt-01-assoc" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public-rt-01.id
}

resource "aws_route_table_association" "public-rt-02-assoc" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public-rt-01.id
}

# Associate private subnets with their respective private route tables
resource "aws_route_table_association" "private-rt-01-assoc" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private-rt-01.id
}

resource "aws_route_table_association" "private-rt-02-assoc" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private-rt-02.id
}
