resource "aws_instance" "public_ec2_instance" {
  ami                         = var.publicEC2_ami_id
  instance_type               = var.publicEC2_instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.public_sg_id]
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true

  tags = {
    Name = var.public_instance_name
  }
}



resource "null_resource" "copy_pem_to_tomcat" {
  depends_on = [aws_instance.public_ec2_instance]

  triggers = {
    tomcat_instance_id = aws_instance.public_ec2_instance.id
  }

  connection {
    host        = aws_instance.public_ec2_instance.public_ip
    user        = "ubuntu"
    type        = "ssh"
    private_key = file("${path.root}/${var.key_name}.pem")
  }

  provisioner "file" {
    source      = "${path.root}/${var.key_name}.pem"
    destination = "/home/ubuntu/${var.key_name}.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ubuntu/${var.key_name}.pem",
      "chown ubuntu:ubuntu /home/ubuntu/${var.key_name}.pem"
    ]
  }
}
