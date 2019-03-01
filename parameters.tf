variable "environment" { default = "test"}
variable "project" { default = "infra"}
variable "repository" { default = "web"}

variable "vpc_cidr" { default = "10.15.0.0/16" }
variable "public_cidr_subnet1" { default = "10.15.101.0/24" }
variable "public_cidr_subnet2" { default = "10.15.102.0/24" }
variable "private_cidr_subnet1" { default = "10.15.201.0/24" }
variable "private_cidr_subnet2" { default = "10.15.202.0/24" }

variable "ami" { default = "ami-0fad7378adf284ce0" }

variable "web_key" { default = "test-infra-web" }
variable "web_instance" { default = "m4.large" }

variable "bastion_key" { default = "test-infra-bastion" }
variable "bastion_instance" { default = "t2.micro" }

### Breakout IP: Please update
variable "BastionIngressIp" { default = "62.30.90.124/32" }

variable "s3bucket" { default = "test-infra-bucket-3384826" }
