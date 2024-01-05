output "payaza_vpc_id" {
  value = aws_vpc.payaza_vpc.id
}

output "public_subnets" {
  value = aws_subnet.payaza_public_subnet.*.id
}

output "simple_api_security_group" {
  value = aws_security_group.simple-api-sg.id
}

output "lb_sg" {
  value = aws_security_group.lb_sg.id
}
