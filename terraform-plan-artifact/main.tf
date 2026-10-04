data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_instance" "plan_artifact_demo" {
  ami           = "ami-0d27e0fb3bac4d724"
  instance_type = var.instance_type

  subnet_id = data.aws_subnets.default.ids[0]

  tags = {
    Name = "AzureDevOps-Terraform-PlanArtifact"
  }
}