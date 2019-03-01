### nat gateway
resource "aws_eip" "nat" {
  vpc      = true
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.infra_public_subnet1.id}"
  depends_on = ["aws_internet_gateway.infra_gw"]
}

### private route table
resource "aws_route_table" "infra_private_rtb" {
    vpc_id = "${aws_vpc.infra_vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
    }
    tags {
        Name = "${var.environment}_${var.project}_${var.repository}_private_rtb"
    }
}
### private route associations
resource "aws_route_table_association" "infra_private1" {
    subnet_id = "${aws_subnet.infra_private_subnet1.id}"
    route_table_id = "${aws_route_table.infra_private_rtb.id}"
}
resource "aws_route_table_association" "infra_private2" {
    subnet_id = "${aws_subnet.infra_private_subnet2.id}"
    route_table_id = "${aws_route_table.infra_private_rtb.id}"
}
