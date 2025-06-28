#SG for ELB
resource "aws_security_group" "elb_sg" {
  name        = "elb_sg"
  description = "elb_sg"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "elb_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_elb" {
  security_group_id = aws_security_group.elb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "https_elb" {
  security_group_id = aws_security_group.elb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "all_elb" {
  security_group_id = aws_security_group.elb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

#SG for EC2 Instance
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "app_sg"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "app_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_app" {
  security_group_id = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.elb_sg.id
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "all_app" {
  security_group_id = aws_security_group.app_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

#SG for RDS DBInstance
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "rds_sg"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "rds_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_3306" {
  security_group_id = aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.app_sg.id
  from_port   = 3306
  ip_protocol = "tcp"
  to_port     = 3306
}

resource "aws_vpc_security_group_egress_rule" "all_rds" {
  security_group_id = aws_security_group.rds_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

