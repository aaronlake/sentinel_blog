# Copyright (c) 2022 Aaron Lake
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

terraform {
  cloud {
    organization = "aaronlake-hashicorp"

    workspaces {
      name = "sentinel-part3"
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
  region = "us-east-2"
}
