output "ALB" {
	value = "${aws_alb.infra_alb.dns_name}"
}

output "BASTION_Public_ip" {
  value       = "${aws_instance.bastion.public_ip}"
}

