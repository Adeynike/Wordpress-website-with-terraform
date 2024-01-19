# launch instance in each private subnet
resource "aws_instance" "app-db" {
    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    instance_type = "t2.micro"

    subnet_id = "${aws_subnet.public-subnet.id}"
    vpc_security_group_ids = ["${aws_security_group.wp-sg.id}"]
    key_name = var.key_name

    tags = {
        Name: "APP-Instance"
    }
}
# // Sends your public key to the instance
# resource "aws_key_pair" "bastion-keypair" {
#     key_name = "bastion-kp"
# }

# launch an instance in db subnet
resource "aws_instance" "mysql-db" {
    ami = "${lookup(var.AMI, var.AWS_REGION)}"
    instance_type = "t2.micro"

    subnet_id = "${aws_subnet.private-subnet.id}"
    vpc_security_group_ids = ["${aws_security_group.mysql-sg.id}"]
    key_name = var.key_name

    tags = {
        Name: "DB-Instance"
    }
}