resource "aws_db_subnet_group" "wordpress" {
  name       = "wordpress-db-subnet-group"
  subnet_ids = [
    data.terraform_remote_state.main.outputs.private_subnet_1a_id,
    data.terraform_remote_state.main.outputs.private_subnet_1c_id,
  ]
  tags = {
    Name = "wordpress-db-subnet-group"
  }
}

resource "aws_db_parameter_group" "mysql_parametergroup" {
  name   = "wordpress-mysql-parameter-group"
  family = "mysql8.0"

  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  tags = {
    Name = "wordpress-mysql-parameter-group"
  }
}

data "aws_ssm_parameter" "db_name" {
  name            = "db_name"       # GUIで設定した名前
  with_decryption = true            
}

data "aws_ssm_parameter" "db_user" {
  name            = "db_user"       # GUIで設定した名前
  with_decryption = true            
}

data "aws_ssm_parameter" "db_password" {
  name            = "db_pass"       # GUIで設定した名前
  with_decryption = true            
}

resource "aws_db_instance" "wordpress" {
  identifier              = "wordpress-db"
  engine                  = "mysql"
  engine_version          = "8.0.40"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  db_name                 = data.aws_ssm_parameter.db_name.value
  username                = data.aws_ssm_parameter.db_user.value
  password                = data.aws_ssm_parameter.db_password.value
  parameter_group_name    = aws_db_parameter_group.mysql_parametergroup.name
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = [data.terraform_remote_state.main.outputs.sg_rds_id]
  db_subnet_group_name    = aws_db_subnet_group.wordpress.name
  multi_az                = false
  tags = {
    Name = "wordpress-db"
  }
}