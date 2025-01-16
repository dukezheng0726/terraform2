# vpc
resource "aws_vpc" "terraform-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "terrafor-vpc"
  }  
}

# internet gateway
resource "aws_internet_gateway" "terraform-gw" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    Name = "terrafor-gw"
  }
}

# route table
resource "aws_route_table" "terraform-public-rt" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-gw.id
  }

  tags = {
    Name = "terraform-public-rt"
  }
}


# add 1 subnet to the route table
resource "aws_subnet" "public-subnet1" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = var.subnet1_cidr

  tags = {
    Name = "public-subnet1"
  }
}

resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.terraform-public-rt.id
}