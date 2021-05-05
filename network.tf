# Get network data
resource "aws_subnet" "example_subnet" {
  count = length(var.subnet.cidr)
  vpc_id = aws_vpc.example_vpc.id
  cidr_block = var.subnet.cidr[count.index]
  availability_zone = var.subnet.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "ExampleVPC-Subnet"
  }
}

data "aws_subnet_ids" "example_subnets" {
  vpc_id = aws_vpc.example_vpc.id
}

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
  tags = {
    Name = "Example-InternetGateway"
  }
}

resource "aws_route_table" "example_crt" {
  vpc_id = aws_vpc.example_vpc.id

  route {
    # associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    # CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "Example-PublicCRT"
  }
}

resource "aws_route_table_association" "example_crta_subnet" {
  count = length(aws_subnet.example_subnet)
  subnet_id = aws_subnet.example_subnet[count.index].id
  route_table_id = aws_route_table.example_crt.id
}

resource "aws_security_group" "example_sgp" {
  vpc_id = aws_vpc.example_vpc.id

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  # http
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # https
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Example-SecurityGroup"
  }
}