##########################################################################
# S3 bucket for config files.
##########################################################################

resource "aws_s3_bucket" "apache-buck-05" {
  bucket = "apache-buck-05"

  tags = {
    Name        = "apache-buck-05"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "buck-versioning" {
  bucket = aws_s3_bucket.apache-buck-05.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "ansible-playbook" {
  bucket = aws_s3_bucket.apache-buck-05.id
  key    = "setup-play.yaml"
  source = "setup-play.yaml"
}

resource "aws_s3_object" "apache-index" {
  bucket = aws_s3_bucket.apache-buck-05.id
  key    = "index.html"
  source = "index.html"
}

resource "aws_s3_object" "cw-config" {
  bucket = aws_s3_bucket.apache-buck-05.id
  key    = "config.json"
  source = "config.json"
}


