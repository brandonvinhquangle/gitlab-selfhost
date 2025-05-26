# AWS resource variables
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "project_prefix" {
  description = "Prefix used for tagging and naming resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04"
  default     = "ami-053b0d53c279acc90"
}

# Register GitLab runner variables
variable "gitlab_url" {
  type = string
}

variable "runner_token" {
  type = string
}
