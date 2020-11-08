data "aws_ami" "ami" {
  owners = ["973714476881"]
  most_recent      = true
  name_regex       = "^Centos-7-DevOps-Practice"
}