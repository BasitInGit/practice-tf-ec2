terraform {
  required_version = "~>1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }

  backend "s3" {
    bucket = "basset-terraform-state"
    region = "eu-west-2"
    key    = "practice-tf-ec2/terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-west-2"
}