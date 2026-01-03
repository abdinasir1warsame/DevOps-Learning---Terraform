# VPC: Main network for the project, includes all public and private subnets
resource "aws_vpc" "vpc-01" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-01"
  }
}

# Internet Gateway: Provides internet access to public subnets (for ALB/NAT)
resource "aws_internet_gateway" "gw-01" {
  vpc_id = aws_vpc.vpc-01.id

  tags = {
    Name = "main"
  }
}

# Public Subnet 1: AZ1, hosts internet-facing resources like ALB or NAT-1
resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.vpc-01.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "public-01"
  }
}

# Private Subnet 1: AZ1, hosts EC2 instances for the app behind NAT
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.vpc-01.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "private-01"
  }
}

# Public Subnet 2: AZ2, hosts internet-facing resources like ALB or NAT-2
resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.vpc-01.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "public-02"
  }
}

# Private Subnet 2: AZ2, hosts EC2 instances for the app behind NAT
resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.vpc-01.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "private-02"
  }
}

# NAT Gateway 1: Provides outbound internet access for private subnet 1 (AZ1)
resource "aws_nat_gateway" "nat-1" {
  allocation_id = aws_eip.nat-1.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = {
    Name = "gw NAT"
  }

  # Ensure NAT is created after the Internet Gateway exists
  depends_on = [aws_internet_gateway.gw-01]
}

# NAT Gateway 2: Provides outbound internet access for private subnet 2 (AZ2)
resource "aws_nat_gateway" "nat-2" {
  allocation_id = aws_eip.nat-2.id
  subnet_id     = aws_subnet.public_subnet2.id

  tags = {
    Name = "gw NAT"
  }

  # Ensure NAT is created after the Internet Gateway exists
  depends_on = [aws_internet_gateway.gw-01]
}
