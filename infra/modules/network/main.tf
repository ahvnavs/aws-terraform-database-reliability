resource "aws_vpc" "vpc" {
    cidr_block = var.cidr[0]
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "${var.env}-vpc"
    }
}

resource "aws_subnet" "pub_sub01" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.cidr[1]
    availability_zone = var.az[0]
    map_public_ip_on_launch = true
}

resource "aws_subnet" "pub_sub02" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.cidr[2]
    availability_zone = var.az[1]
    map_public_ip_on_launch = true
}

resource "aws_subnet" "pri_sub01" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.cidr[3]
    availability_zone = var.az[0]
    map_public_ip_on_launch = false
}

resource "aws_subnet" "pri_sub02" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.cidr[4]
    availability_zone = var.az[1]
    map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
}

resource "aws_eip" "eip" {
}

resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.eip.id
    subnet_id = aws_subnet.pub_sub01.id
    tags = {
        Name = "${var.env}-nat-gateway"
    }
}

resource "aws_route_table" "pub_route" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "${var.env}-public-route-table"
    }
}

resource "aws_route_table_association" "asso_pub_01" {
    subnet_id      = aws_subnet.pub_sub01.id
    route_table_id = aws_route_table.pub_route.id
}

resource "aws_route_table_association" "asso_pub_02" {
    subnet_id      = aws_subnet.pub_sub02.id
    route_table_id = aws_route_table.pub_route.id
}

resource "aws_route_table" "pri_route" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
    tags = {
        Name = "${var.env}-private-route-table"
    }
}

resource "aws_route_table_association" "asso_pri_01" {
    subnet_id      = aws_subnet.pri_sub01.id
    route_table_id = aws_route_table.pri_route.id
}

resource "aws_route_table_association" "asso_pri_02" {
    subnet_id      = aws_subnet.pri_sub02.id
    route_table_id = aws_route_table.pri_route.id
}
