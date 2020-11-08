resource "aws_instance" "ami-instance" {
  ami = data.aws_ami.ami.id
  instance_type = ""
}