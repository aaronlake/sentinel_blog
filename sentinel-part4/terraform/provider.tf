terraform {
  cloud {
    organization = "aaronlake-hashicorp"

    workspaces {
      name = "sentinel-part4"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}
