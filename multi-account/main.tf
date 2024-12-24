provider "aws" {
  region = "us-east-1"
  alias = "account-1"

}

provider "aws" {
  region = "ap-south-1"
  alias = "account-2"

  assume_role {
    role_arn     = "arn:aws:iam::041445559784:role/assume-role2"
    session_name = "terraform-session-account2"
  }
}


resource "aws_instance" "account-1" {
  provider = aws.account-1
  ami = "ami-01816d07b1128cd2d"
  instance_type = "t2.micro"

  tags = {
    Name = "account-1"
  }
}


resource "aws_instance" "account-2" {
  provider = aws.account-2
  ami = "ami-0fd05997b4dff7aac"
  instance_type = "t2.micro"

  tags = {
    Name = "account-2"
  }
}