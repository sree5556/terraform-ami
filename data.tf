data "aws_ami" "ami" {
  owners = ["973714476881"]
  most_recent      = true
  name_regex       = "^Centos-7-DevOps-Practice"
}

data "aws_secretsmanager_secret" "cred" {
  name = "roboshop-Skeys"
}
data "aws_secretsmanager_secret_version" "cred" {
  secret_id = data.aws_secretsmanager_secret.cred.id
//  check the screenshots
}
