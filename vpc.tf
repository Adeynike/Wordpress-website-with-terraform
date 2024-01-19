resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"

    tags = {
        Name = "my-vpc"
    }
}
# public subnets
resource "aws_subnet" "public-subnet" {
    vpc_id = "${aws_vpc.my-vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" # This is what makes it a public subnet
    availability_zone = "us-east-1a"
    tags = {
        Name = "public-subnet"
    }
}

# private subnets
resource "aws_subnet" "private-subnet" {
    vpc_id = "${aws_vpc.my-vpc.id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    tags = {
        Name = "private-subnet"
    }
}

resource "aws_subnet" "db-private-subnet" {
    vpc_id = "${aws_vpc.my-vpc.id}"
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1c"
    tags = {
        Name = "db-private-subnet"
    }
}

resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "main"
  subnet_ids = [aws_subnet.db-private-subnet.id, aws_subnet.private-subnet.id]

  tags = {
    Name = "My DB subnet group"
  }
}