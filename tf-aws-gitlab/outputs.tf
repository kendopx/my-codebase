# output "public_ip" {
#   value       = formatlist("%s: %s", aws_instance.gitlab.*.public_dns, aws_instance.gitlab.*.public_ip)
#   description = "Public IP Address of EC2 instance"
# }


output "id" {
  description = "Contains the EIP allocation ID"
  value       = aws_eip.gitlab_eip.id
}

output "public_ip" {
  description = "Contains the public IP address"
  value       = aws_eip.gitlab_eip.public_ip
}

output "instance_id" {
  value       = aws_instance.gitlab.*.id
  description = "Instance ID"
}

output "ssh_connection" {
  value       = "ssh ec2-user@${aws_eip.gitlab_eip.public_ip}"
  description = "Connect via SSH"
}
output "gitlab_url" {
  description = "The public IP address of the gitlab server"
  value       = "http://gitlab.emagetech.co"
}

