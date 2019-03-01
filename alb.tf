resource "aws_security_group" "alb-sg" {
  vpc_id = "${aws_vpc.infra_vpc.id}"
  name = "test_infra_web_alb"
  description = "security group for application load balancer"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "${var.environment}_${var.project}_${var.repository}_alb_sg"
  }
}

resource "aws_alb" "infra_alb" {
  name = "${var.environment}-${var.project}-${var.repository}-alb"
  security_groups = ["${aws_security_group.alb-sg.id}"]
  subnets = ["${aws_subnet.infra_public_subnet1.id}","${aws_subnet.infra_public_subnet2.id}"]
#  access_logs {
#    bucket  = "${aws_s3_bucket.bucket.bucket}"
#    prefix  = "alb-logs"
#    enabled = true
#  }
  tags {
    Name = "${var.environment}_${var.project}_${var.repository}_alb"
  }
}

resource "aws_alb_target_group" "alb_target" {
  name = "alb-tg"
  port = "80"
  protocol = "HTTP"
  vpc_id = "${aws_vpc.infra_vpc.id}"
}

resource "aws_placement_group" "alb_placement" {
  name     = "${var.environment}_${var.project}_${var.repository}_placement"
  strategy = "cluster"
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_alb.infra_alb.arn}"
  port = "80"
  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target.arn}"
    type = "forward"
  }
}
