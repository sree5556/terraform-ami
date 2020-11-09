resource "aws_instance" "ami-instance" {
  ami = data.aws_ami.ami.id
  instance_type = "t3.medium"
  vpc_security_group_ids = [aws_security_group.allow-ssh-for-ami.id]
}


resource "null_resource" "apply" {
  provisioner "remote-exec" {
    connection {
      host = aws_instance.ami-instance.public_ip
      user = jsondecode(data.aws_secretsmanager_secret_version.cred.secret_string)["SSH_USER"]
      password = jsondecode(data.aws_secretsmanager_secret_version.cred.secret_string)["SSH_PASS"]

    }
    inline = [
      "sudo pip install ansible",
      "echo localhost >/tmp/hosts",
      "ansible pull -i hosts -U https://sreenivasyandamuri44@dev.azure.com/sreenivasyandamuri44/Devops/_git/ansible roboshop.yml -t ${var.component} -e component=${var.component} -e PAT=${var.PAT}"
//      configure in frontend environment variables TF_VAR_component = frontend  TF_VAR_PAT = frv55tygynnx7rqcdm6j2opdmsjje7ufabfynpnxikern5x3hhka

    ]
  }
}

//The "count" value depends on resource attributes that cannot be determined
//2020-11-08T08:01:40.6152340Z until apply, so Terraform cannot predict how many instances will be created.
//2020-11-08T08:01:40.6152937Z To work around this, use the -target argument to first apply only the
//2020-11-08T08:01:40.6153253Z resources that the count depends on.
resource "aws_security_group" "allow-ssh-for-ami" {
  name        = "allow-ssh-for-ami-${var.component}"
  description = "allow-ssh-for-ami-${var.component}"


  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh-for-ami-${var.component}"
  }
}

module "files" {
  source = "matti/resource/shell"
  command = "date +%s"
}
resource "aws_ami_from_instance" "ami" {
  name = "${var.component}-${module.files.stdout}"
  source_instance_id = aws_instance.ami-instance.id
}
