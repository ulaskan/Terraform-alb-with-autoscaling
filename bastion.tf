resource "aws_security_group" "bastion_sg" {
  vpc_id = "${aws_vpc.infra_vpc.id}"
  name = "bastion_sg"
  description = "security group that allows ssh into the network"
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
      cidr_blocks = ["${var.BastionIngressIp}"]
  }
  tags {
    Name = "${var.environment}_${var.project}_${var.repository}_bastion_sg"
  }
}

resource "aws_instance" "bastion" {
  ami = "${var.ami}"
  instance_type = "${var.bastion_instance}"
  key_name = "${var.bastion_key}"
  subnet_id = "${aws_subnet.infra_public_subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
  tags {
    Name = "${var.environment}_${var.project}_${var.repository}_bastion"
  }
}
