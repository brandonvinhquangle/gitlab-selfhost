resource "null_resource" "upload_setup_scripts" {
  depends_on = [aws_instance.gitlab_server]

  connection {
    type        = "ssh"
    host        = aws_instance.gitlab_server.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.ssh_key.private_key_pem
  }

  # Upload gitlab-config.sh as-is
  provisioner "file" {
    source      = "${path.module}/gitlab/gitlab-config.sh"
    destination = "/home/ubuntu/gitlab-config.sh"
  }

  # Upload runner-config.sh rendered from a template
  provisioner "file" {
    content     = templatefile("${path.module}/runner/runner-config.sh.tpl", {
      gitlab_url   = "http://${aws_instance.gitlab_server.public_ip}",
      runner_token = var.runner_token
    })
    destination = "/home/ubuntu/runner-config.sh"
  }
}
