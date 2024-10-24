provider "aws" {
  region    = "us-east-1"
  profile   = "default"
}

############ SAVING TF STATE FILE #########
terraform {
  backend "s3" {
    bucket  = "terraform-bd-atlantis"
    key     = "atlantis/terraform.tfstate"
    region  = "us-east-1"
    profile = "default"
  }
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "mypublic_subnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"  # Change to your desired AZ

  tags = {
    Name = "mypublic_subnet"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.small"
  subnet_id     = aws_subnet.mypublic_subnet.id

  tags = {
    Name = "app_server"
  }
}
