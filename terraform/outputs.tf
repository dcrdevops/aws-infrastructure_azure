output "instance_id" {
  value = aws_instance.devops_demo.id
}

output "instance_public_ip" {
  value = aws_instance.devops_demo.public_ip
}