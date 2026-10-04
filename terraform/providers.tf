terraform {
    required_version = ">= 1.5.0"

    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
      }
    }
    
    backend "s3" {
        bucket = "azure-devops-terraform-state-029730857940"
        key = "azure-devops-poc/terraform.tfstate"
        region = "us-east-1"
    }
}

provider "aws" {
    region = "us-east-1"
}