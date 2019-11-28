# Vpc.tf Official Code
# Create the VPC
resource "aws_vpc" "VPC_Official" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
tags = {
  Name = "VPC_Official"
  }
}
# Create Secondary Cidr
resource "aws_vpc_ipv4_cidr_block_association" "VPC_second_cidr" {
  vpc_id                  = "${aws_vpc.VPC_Official.id}"
  cidr_block              = "10.100.0.0/16"
}
# Create the Subnets
resource "aws_subnet" "private_1" {
  vpc_id                  = "${aws_vpc.VPC_Official.id}"
  cidr_block              = "10.0.0.0/20"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2a"
  tags = {
    Name = "private_1"
  }
}
resource "aws_subnet" "private_2" {
  vpc_id                  = "${aws_vpc.VPC_Official.id}"
  cidr_block              = "10.0.32.0/20"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2b"
tags = {
   Name = "private_2"
  }
}
resource "aws_subnet" "private_3" {
  vpc_id                  = "${aws_vpc.VPC_Official.id}"
  cidr_block              = "10.0.64.0/20"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-west-2c"
tags = {
   Name = "private_3"
  }
}
resource "aws_subnet" "public_1" {
  vpc_id                  = "${aws_vpc.VPC_Official.id}"
  cidr_block              = "10.100.0.0/20"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2a"
tags = {
   Name = "public_1"
  }
}
resource "aws_subnet" "public_2" {
  vpc_id                  = "${aws_vpc.VPC_Official.id}"
  cidr_block              = "10.100.16.0/20"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2b"
tags = {
   Name = "public_2"
  }
}
resource "aws_subnet" "public_3" {
  vpc_id                  = "${aws_vpc.VPC_Official.id}"
  cidr_block              = "10.100.32.0/20"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-west-2c"
tags = {
   Name = "public_3"
  }
 }
# Create the Security Group
resource "aws_security_group" "SG_Official" {
  vpc_id       = "${aws_vpc.VPC_Official.id}"
  name         = "SG_Official"
  description  = "default VPC security group"
  ingress {
    from_port    = 22
    to_port      = 22
    protocol     = "tcp"
    cidr_blocks  = ["0.0.0.0/0"] 
}
  ingress {
    from_port    = 80
    to_port      = 80
    protocol     = "tcp"
    cidr_blocks  = ["0.0.0.0/0"] 
}
   ingress {
    from_port    = 443
    to_port      = 443
    protocol     = "tcp"
    cidr_blocks  = ["0.0.0.0/0"] 
}
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}
tags = {
        Name = "SG_Official"
}
}
# Create VPC Network Access Control List
resource "aws_network_acl" "ACL_Official" {
  vpc_id       = "${aws_vpc.VPC_Official.id}"
  subnet_ids   = [ "${aws_subnet.private_1.id}" ]
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
}
  ingress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
}
 ingress {
   protocol    = "tcp"
   rule_no     = 200
   action      = "allow"
   cidr_block  = "0.0.0.0/0"
   from_port   = 22
   to_port     = 22
}
 ingress {
   protocol    = "tcp"
   rule_no     = 250
   action      = "allow"
   cidr_block  = "0.0.0.0/0"
   from_port   = 1024
   to_port     = 65535
}
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
}
  egress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
}
 egress {
   protocol    = "tcp"
   rule_no     = 200
   action      = "allow"
   cidr_block  = "0.0.0.0/0"
   from_port   = 22
   to_port     = 22
}
 egress {
   protocol    = "tcp"
   rule_no     = 250
   action      = "allow"
   cidr_block  = "0.0.0.0/0"
   from_port   = 1024
   to_port     = 65535
}
tags = {
    Name = "ACL_Official"
  }
}
# Create the Internet Gateway
resource "aws_internet_gateway" "IG_Official" {
  vpc_id = "${aws_vpc.VPC_Official.id}"
tags = {
        Name = "IG_Official"
    }
}
# Create the Route Table
resource "aws_route_table" "Route_Table1" {
    vpc_id = "${aws_vpc.VPC_Official.id}"
tags = {
        Name = "Route_Table1"
    }
}
# Create the Internet Access
resource "aws_route" "My_VPC_Internet_Access" {
  route_table_id         = "${aws_route_table.Route_Table1.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.IG_Official.id}"
}
# Associate the Route Table with the Subnet
resource "aws_route_table_association" "My_VPC_Association" {
    subnet_id      = "${aws_subnet.private_1.id}"
    route_table_id = "${aws_route_table.Route_Table1.id}"
}
resource "aws_route_table_association" "My_VPC_Association2" {
    subnet_id      = "${aws_subnet.private_2.id}"
    route_table_id = "${aws_route_table.Route_Table1.id}"
}
resource "aws_route_table_association" "My_VPC_Association3" {
    subnet_id      = "${aws_subnet.private_3.id}"
    route_table_id = "${aws_route_table.Route_Table1.id}"
}
# Create the 2nd Route Table for public subnets
resource "aws_route_table" "Route_Table2" {
    vpc_id = "${aws_vpc.VPC_Official.id}"
tags = {
        Name = "Route_Table2"
    }
}
# Create the Internet Access
resource "aws_route" "My_VPC_Internet_Access2" {
  route_table_id         = "${aws_route_table.Route_Table2.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.IG_Official.id}"
}
# Associate the Route Table with the Subnet
resource "aws_route_table_association" "My_VPC_Association21" {
    subnet_id      = "${aws_subnet.public_1.id}"
    route_table_id = "${aws_route_table.Route_Table2.id}"
}
resource "aws_route_table_association" "My_VPC_Association22" {
    subnet_id      = "${aws_subnet.public_2.id}"
    route_table_id = "${aws_route_table.Route_Table2.id}"
}
resource "aws_route_table_association" "My_VPC_Association23" {
    subnet_id      = "${aws_subnet.public_3.id}"
    route_table_id = "${aws_route_table.Route_Table2.id}"
}
#Create EIP to be Associated with the NAT Gateway
resource "aws_eip" "elastic-ip-for-nat-gw" {
    vpc = true
    associate_with_private_ip = "10.0.10.0"
    tags = {
    Name = "EIP_NAT"
  }
}
# Create NAT Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.elastic-ip-for-nat-gw.id}"
  subnet_id     = "${aws_subnet.public_1.id}"
  tags = {
    Name = "nat-gw"
  }
  depends_on = ["aws_eip.elastic-ip-for-nat-gw"]
}