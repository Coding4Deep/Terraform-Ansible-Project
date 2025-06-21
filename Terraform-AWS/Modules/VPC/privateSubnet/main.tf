resource "aws_subnet" "private_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.private_az

  tags = {
    Name = "Terraform_Private_Subnet"
  }
}
resource "aws_eip" "private_nat_gateway" {
  tags = {
    Name = "Terraform_Private_NAT_Gateway_EIP"
  }
}

resource "aws_nat_gateway" "private_nat_gateway" {
  allocation_id = aws_eip.private_nat_gateway.id
  subnet_id    = aws_subnet.private_subnet.id

  tags = {
    Name = "Terraform_Private_NAT_Gateway"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private_nat_gateway.id
  }

  tags = {
    Name = "Terraform_Private_Route_Table"
  }
}
resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

