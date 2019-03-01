resource "aws_iam_role" "s3-role" {
    name = "s3-role"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "s3-role-policy" {
    name = "s3ReadWritePolicy"
    role = "${aws_iam_role.s3-role.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::test-infra-bucket-3384826",
              "arn:aws:s3:::test-infra-bucket-3384826/*"
            ]
        }
    ]
}
EOF
}
