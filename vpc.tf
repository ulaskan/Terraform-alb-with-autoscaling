### VPC
resource "aws_vpc" "infra_vpc" {
  cidr_block = "${var.vpc_cidr}"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  tags {
    Name = "${var.environment}_${var.project}_${var.repository}_vpc"
  }
}

### Public Subnets
resource "aws_subnet" "infra_public_subnet1" {
    vpc_id = "${aws_vpc.infra_vpc.id}"
    cidr_block = "${var.public_cidr_subnet1}"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-1a"
    tags {
        Name = "${var.environment}_${var.project}_${var.repository}_public_subnet1"
    }
}
resource "aws_subnet" "infra_public_subnet2" {
    vpc_id = "${aws_vpc.infra_vpc.id}"
    cidr_block = "${var.public_cidr_subnet2}"
    map_public_ip_on_launch = "true"
    availability_zone = "eu-west-1b"
    tags {
        Name = "${var.environment}_${var.project}_${var.repository}_public_subnet2"
    }
}

### Private Subnets
resource "aws_subnet" "infra_private_subnet1" {
    vpc_id = "${aws_vpc.infra_vpc.id}"
    cidr_block = "${var.private_cidr_subnet1}"
    map_public_ip_on_launch = "false"
    availability_zone = "eu-west-1a"
    tags {
        Name = "${var.environment}_${var.project}_${var.repository}_private_subnet1"
    }
}
resource "aws_subnet" "infra_private_subnet2" {
    vpc_id = "${aws_vpc.infra_vpc.id}"
    cidr_block = "${var.private_cidr_subnet2}"
    map_public_ip_on_launch = "false"
    availability_zone = "eu-west-1b"
    tags {
        Name = "${var.environment}_${var.project}_${var.repository}_private_subnet1"
    }
}

### Internet Gateway
resource "aws_internet_gateway" "infra_gw" {
    vpc_id = "${aws_vpc.infra_vpc.id}"
    tags {
        Name = "${var.environment}_${var.project}_${var.repository}_igw"
    }
}

### route tables
resource "aws_route_table" "infra_rtb" {
    vpc_id = "${aws_vpc.infra_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.infra_gw.id}"
    }
    tags {
        Name = "${var.environment}_${var.project}_${var.repository}_rtb"
    }
}

### public subnet route associations
resource "aws_route_table_association" "infra_public1" {
    subnet_id = "${aws_subnet.infra_public_subnet1.id}"
    route_table_id = "${aws_route_table.infra_rtb.id}"
}

resource "aws_route_table_association" "infra_public2" {
    subnet_id = "${aws_subnet.infra_public_subnet2.id}"
    route_table_id = "${aws_route_table.infra_rtb.id}"
}
