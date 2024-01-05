output "payaza_test_lb" {
  value = aws_lb.payaza_test_lb.id
}

output "payaza_test_api_tg_arn" {
  value = aws_lb_target_group.payaza_test_simple_api_tg.arn
}

output "payaza_test_lb_dns" {
  value = aws_lb.payaza_test_lb.dns_name
}