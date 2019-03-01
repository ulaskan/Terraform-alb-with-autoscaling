resource "aws_s3_bucket" "bucket" {
  bucket = "${var.s3bucket}"
  acl    = "private"
  tags {
    Name = "${var.environment}_${var.project}_${var.repository}_bucket"
  }
}
