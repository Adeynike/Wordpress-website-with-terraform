# Add internet gateway
resource "aws_internet_gateway" "public-igw" {
    vpc_id = "${aws_vpc.my-vpc.id}"
    tags = {
        Name = "public-igw"
    }
}

# Public routes
resource "aws_route_table" "public-route-table" {
    vpc_id = "${aws_vpc.my-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = "${aws_internet_gateway.public-igw.id}" 
    }

    tags = {
        Name = "public-route-table"
    }
}
resource "aws_route_table_association" "public-subnet-associate"{
    subnet_id = "${aws_subnet.public-subnet.id}"
    route_table_id = "${aws_route_table.public-route-table.id}"
}

# Private routes
resource "aws_route_table" "private-route-table" {
    vpc_id = "${aws_vpc.my-vpc.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.private-nat-gateway.id
    }

    tags = {
        Name = "private-route-table"
    }
}

resource "aws_route_table_association" "private-subnet-associate"{
    subnet_id = "${aws_subnet.private-subnet.id}"
    route_table_id = "${aws_route_table.private-route-table.id}"
}

# NAT Gateway to allow private subnet to connect out the way
resource "aws_eip" "nat_gateway" {
    vpc = true
}
resource "aws_nat_gateway" "private-nat-gateway" {
    allocation_id = aws_eip.nat_gateway.id
    subnet_id     = "${aws_subnet.public-subnet.id}"

    tags = {
    Name = "VPC - NAT"
    }

    # To ensure proper ordering, add Internet Gateway as dependency
    depends_on = [aws_internet_gateway.public-igw]
}

# Security Group for App layer
resource "aws_security_group" "wp-sg" {
    vpc_id = "${aws_vpc.my-vpc.id}"

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // Do not use this in production, should be limited to your own IP
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ssh-allowed"
    }
}

# Security Group for DB layer
resource "aws_security_group" "mysql-sg" {
    vpc_id = "${aws_vpc.my-vpc.id}"

    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        // Do not use this in production, should be limited to your own IP
        security_groups = [aws_security_group.wp-sg.id]
    }

    tags = {
        Name = "mysql-sg"
    }
}