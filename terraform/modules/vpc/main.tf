resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "private" {
  count = 3
  cidr_block = element(["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"], count.index)
  vpc_id     = aws_vpc.main.id

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "public" {
  cidr_block = "10.0.0.0/24"
  vpc_id     = aws_vpc.main.id

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_route_table" "private" {
  count = 3
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private" {
  count = 3
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = element(aws_route_table.private[*].id, count.index)
}

resource "aws_nat_gateway" "main" {
  count = 3
  allocation_id = aws_instance.nat_gateway[count.index].network_interface_ids[0]
  subnet_id     = element(aws_subnet.public[*].id, count.index)
  tags = {
    Name = "nat-gateway-${count.index + 1}"
  }
}

resource "aws_instance" "nat_gateway" {
  count = 3
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  key_name      = "key-name"
  subnet_id     = element(aws_subnet.public[*].id, count.index)

  tags = {
    Name = "nat-instance-${count.index + 1}"
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "private_subnets" {
  value = aws_subnet.private.*.id
}

output "public_subnet" {
  value = aws_subnet.public.id
}
