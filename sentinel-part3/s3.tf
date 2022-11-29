# Copyright (c) 2022 Aaron Lake
# 
# This software is released under the MIT License.
# https://opensource.org/licenses/MIT

# Generate a random string for the bucket name
resource "random_uuid" "uuid" {}

# Create an S3 bucket
resource "aws_s3_bucket" "sentinel-part3" {
  bucket = "${random_uuid.uuid.result}-sentinel-part3"

  tags = {
    "Project"     = "Demo"
    "Environment" = "Development"
    "Department"  = "Engineering"
  }
}

resource "aws_s3_bucket_acl" "sentinel-part3" {
  bucket = aws_s3_bucket.sentinel-part3.id
  acl    = "private"
}
