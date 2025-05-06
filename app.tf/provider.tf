terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
  }
}
terraform {
  backend "s3" {
    bucket  = "benefit.bkt"
    key = "dev-tf.tfstate"
    region = "ap-southeast-2"
    encrypt        = true
  }
}
provider "aws" {
  region  = "ap-southeast-2" 
}
