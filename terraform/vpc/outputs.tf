output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_1a_id" {
  value = aws_subnet.public_1a.id
}

output "public_subnet_1c_id" {
  value = aws_subnet.public_1c.id
}

output "private_subnet_1a_id" {
  value = aws_subnet.private_1a.id
}

output "private_subnet_1c_id" {
  value = aws_subnet.private_1c.id
}

output "sg_elb_id" {
  value = aws_security_group.elb_sg.id
}

output "sg_app_id" {
  value = aws_security_group.app_sg.id
}

output "sg_rds_id" {
  value = aws_security_group.rds_sg.id
}
