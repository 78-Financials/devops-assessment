output "payaz_test_cluster_name" {
  value = aws_ecs_cluster.payaza_test_ecs_cluster.name
}

output "simple_api_name" {
  value = aws_ecs_service.simple_api.name
}