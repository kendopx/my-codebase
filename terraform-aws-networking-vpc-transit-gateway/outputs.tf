output "public_subnets_a" {
  value = module.vpc_a.public_subnets
}
output "public_subnets_b" {
  value = module.vpc_b.public_subnets
}
output "public_subnets_c" {
  value = module.vpc_c.public_subnets
}
output "vpc_a_public_host_IP" {
  value = module.vpc_a_public_host.public_ip
}
output "vpc_b_public_host_IP" {
  value = module.vpc_b_public_host.public_ip
}
output "vpc_c_public_host_IP" {
  value = module.vpc_c_public_host.public_ip
}
output "transit_gateway_id" {
  value = module.transit_gateway.transit_gateway_id
}