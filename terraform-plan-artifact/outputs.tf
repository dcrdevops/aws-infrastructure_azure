output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.plan_artifact_demo.id
}

output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.plan_artifact_demo.public_ip
}

output "instance_type" {
  description = "EC2 instance type"
  value       = aws_instance.plan_artifact_demo.instance_type
}