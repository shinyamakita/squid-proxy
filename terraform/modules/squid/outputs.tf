output "proxy_ip" {
  description = "Proxy server public IP"
  value       = aws_eip.squid.public_ip
}

output "cluster_name" {
  description = "ECS Cluster name"
  value       = module.ecs_cluster.cluster_name
}

output "service_name" {
  description = "ECS Service name"
  value       = aws_ecs_service.squid.name
}

output "eip_allocation_id" {
  value = aws_eip.squid.allocation_id
}