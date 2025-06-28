resource "aws_key_pair" "keypair" {
  key_name   = "terraform-keypair"
  public_key = file("~/.ssh/terraform-ec2.pub")

  tags = {
    Name    = "terraform-keypair"
  }
}

resource "aws_instance" "wordpress_app" {
  count = 2

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id = element([
  data.terraform_remote_state.main.outputs.public_subnet_1a_id,
  data.terraform_remote_state.main.outputs.public_subnet_1c_id
], count.index)# AZ分散
  associate_public_ip_address = false # EIPを付けるので false にする
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [data.terraform_remote_state.main.outputs.sg_app_id]
  key_name = aws_key_pair.keypair.key_name


  tags = {
    Name = "wordpress-app-${count.index + 1}"
  }
}

resource "aws_eip" "wordpress_app_eip" {
  count = 2

  instance = aws_instance.wordpress_app[count.index].id

  tags = {
    Name = "wordpress-app-eip-${count.index + 1}"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  owners = ["amazon"] # Amazon公式
}

output "latest_ami_id" {
  value = data.aws_ami.amazon_linux.id
}