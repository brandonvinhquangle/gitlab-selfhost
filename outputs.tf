output "gitlab_public_ip" {
  value       = aws_instance.gitlab_server.public_ip
  description = "Public IP of the GitLab EC2 instance"
}
