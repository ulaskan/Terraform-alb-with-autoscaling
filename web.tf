resource "aws_security_group" "web_sg" {
  vpc_id = "${aws_vpc.infra_vpc.id}"
  name = "web_sg"
  description = "security group that allows ssh, http and all egress traffic"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      security_groups = ["${aws_security_group.bastion_sg.id}"]
  }
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      security_groups = ["${aws_security_group.alb-sg.id}"]
  }
  tags {
    Name = "${var.environment}_${var.project}_${var.repository}_web_sg"
  }
}

resource "aws_iam_instance_profile" "s3-role-instanceprofile" {
    name = "s3-access-role"
    role = "${aws_iam_role.s3-role.name}"
}

resource "aws_launch_configuration" "infra_launchconfig" {
  name_prefix = "infra_launchconfig"
  image_id = "${var.ami}"
  instance_type = "${var.web_instance}"
  key_name = "${var.web_key}"
  security_groups = ["${aws_security_group.web_sg.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.s3-role-instanceprofile.name}"
  user_data = "#!/bin/bash\nsudo yum install httpd -y\nsudo systemctl enable httpd\nsudo systemctl start httpd"
  lifecycle { create_before_destroy = true }
}
