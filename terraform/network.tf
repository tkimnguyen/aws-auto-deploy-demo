# Create VPC for our servers
resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "cloudconf-demo-vpc"
  }
}

# Create a subnet for servers to live in
resource "aws_subnet" "servers" {
  vpc_id = aws_vpc.demo-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "${var.region}a"
  tags = {
    Name = "Cloud Conf Demo"
  }
}

# Create internet gateway and attach it to created VPC
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.demo-vpc.id
}

# Create route table
resource "aws_route_table" "routing_table" {
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    "Name" = "Paired to subnet AZ${length(var.vm_names)}"
  }
}

# Attach route table to subnet
resource "aws_route_table_association" "table" {
  route_table_id = aws_route_table.routing_table.id
  subnet_id = aws_subnet.servers.id
}

# Create security group for web traffic
resource "aws_security_group" "web-acl" {
  name = "web-acl"
  description = "Web access to instances"
  vpc_id = aws_vpc.demo-vpc.id
  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = "443"
    to_port = "443"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create security group for ssh traffic
resource "aws_security_group" "ssh-acl" {
  name = "ssh-acl"
  description = "SSH Access to instances"
  vpc_id = aws_vpc.demo-vpc.id
  ingress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create security group for salt traffic
resource "aws_security_group" "salt-acl" {
  name = "salt-acl"
  description = "Access for the salt master"
  vpc_id = aws_vpc.demo-vpc.id
  ingress {
    from_port = "4505"
    to_port = "4505"
    protocol = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  ingress {
    from_port = "4506"
    to_port = "4506"
    protocol = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
