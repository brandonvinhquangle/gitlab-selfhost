resource "null_resource" "register_runner" {
  depends_on = [aws_instance.gitlab_server]

  connection {
    type        = "ssh"
    host        = aws_instance.gitlab_server.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.ssh_key.private_key_pem
  }

  provisioner "file" {
    content     = templatefile("${path.module}/runner/runner-config.sh.tpl", {
      gitlab_url   = var.gitlab_url,
      runner_token = var.runner_token
    })
    destination = "/home/ubuntu/runner-config.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/runner-config.sh",
      "sudo /home/ubuntu/runner-config.sh"
    ]
  }
}
