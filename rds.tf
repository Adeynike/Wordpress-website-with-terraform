resource "aws_db_instance" "mysql-db" {
  identifier        = var.identifier
  storage_type      = var.storage_type
  allocated_storage = var.allocated_storage

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  port           = var.port

  db_subnet_group_name = aws_db_subnet_group.db-subnet-group.id
  db_name              = var.db_name

  username               = var.username
  password               = var.password
  availability_zone      = var.availability_zone
  vpc_security_group_ids = ["${aws_security_group.mysql-sg.id}"]
  publicly_accessible    = false
  deletion_protection    = false
  skip_final_snapshot    = true

  tags = {
    name = "Demo MYSQL RDS Instance"
  }
}