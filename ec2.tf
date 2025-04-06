#creating ec2 for dev vpc

resource "aws_instance" "web_vm" {
  ami                         = data.aws_ami.linux_Server_pr.id
  instance_type               = "t2.micro"
  key_name                    = var.key
  subnet_id                   = aws_subnet.dev_public_subnet.id
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "dev-Web-Server"
  }
}

resource "aws_instance" "app_vm" {
  ami                         = data.aws_ami.linux_Server_pr.id
  instance_type               = "t2.micro"
  key_name                    = var.key
  subnet_id                   = aws_subnet.dev_private_subnet.id
  security_groups             = [aws_security_group.web_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "dev-App-Server"
  }
}


##############################################################################

## Creating VMs for uat and qa environment

resource "aws_instance" "qa_web" {
  ami             = data.aws_ami.linux_Server_pr.id
  instance_type   = "t2.micro"
  key_name        = var.key
  subnet_id       = aws_subnet.qa_private_subnet.id
  security_groups = [aws_security_group.qa_sg.id]

  tags = {
    Name = "qa-server"
  }
}

resource "aws_instance" "app_vm_sr" {
  ami             = data.aws_ami.linux_Server_pr.id
  instance_type   = "t2.micro"
  key_name        = var.key
  subnet_id       = aws_subnet.uat_private_subnet.id
  security_groups = [aws_security_group.uat_sg.id]

  tags = {
    Name = "uat-server"
  }
}