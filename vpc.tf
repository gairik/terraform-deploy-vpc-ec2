# vpc.tf 
# Create VPC/Subnet/Security Group/Network ACL
provider "aws" {
  access_key = var.access_key 
  secret_key = var.secret_key 
  region     = var.region
}
# create the VPC
resource "aws_vpc" "My_VPC_terraform" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
tags = {
    Name = "terraform VPC"
}
} # end resource

# create public Subnet 
resource "aws_subnet" "My_VPC_terraform_Subnet_public" {
  vpc_id                  = aws_vpc.My_VPC_terraform.id
  cidr_block              = "${var.subnetCIDRblock[0]}"
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone[0]
tags = {
   Name = "My VPC Subnet"
}
} # end resource


# create private Subnet 1 
resource "aws_subnet" "My_VPC_terraform_Subnet_private1" {
  vpc_id                  = aws_vpc.My_VPC_terraform.id
  cidr_block              = "${var.subnetCIDRblock[1]}"
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone[0]
tags = {
   Name = "My VPC Subnet"
}
} # end resource


# create private Subnet 2
resource "aws_subnet" "My_VPC_terraform_Subnet_private2" {
  vpc_id                  = aws_vpc.My_VPC_terraform.id
  cidr_block              = "${var.subnetCIDRblock[2]}"
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone[0]
tags = {
   Name = "My VPC Subnet"
}
} # end resource

# Create the Security Group
resource "aws_security_group" "My_VPC_terraform_Security_Group" {
  vpc_id       = aws_vpc.My_VPC_terraform.id
  name         = "My VPC Security Group"
  description  = "My VPC Security Group"
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  } 
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
   Name = "My VPC Security Group"
   Description = "My VPC Security Group"
}
} # end resource

# Create the Internet Gateway
resource "aws_internet_gateway" "My_VPC_terraform_GW" {
 vpc_id = aws_vpc.My_VPC_terraform.id
 tags = {
        Name = "My VPC Internet Gateway"
}
} # end resource
# Create the Route Table
resource "aws_route_table" "My_VPC_terraform_route_table" {
 vpc_id = aws_vpc.My_VPC_terraform.id
 tags = {
        Name = "My VPC Route Table"
}
} # end resource

# Create the Internet Access
resource "aws_route" "My_VPC_terraform_internet_access" {
  route_table_id         = aws_route_table.My_VPC_terraform_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.My_VPC_terraform_GW.id
} # end resource

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "My_VPC_terraform_association" {
  subnet_id      = aws_subnet.My_VPC_terraform_Subnet_public.id
  route_table_id = aws_route_table.My_VPC_terraform_route_table.id
} # end resource
# end vpc.tf

resource "aws_instance" "terraform_ec2" {
  ami           = var.ec2AMI
  instance_type = "t2.micro"
  subnet_id = aws_subnet.My_VPC_terraform_Subnet_public.id
  key_name = "ansible-3"
  user_data = "${file("script.sh")}"
  tags = {
    Name = "public ec2 terraform"
  }
}