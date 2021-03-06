
output "webserveripaddress" {
    value = aws_instance.webserver[*].public_ip
}
resource "aws_instance" "webserver" {
   count = var.instance_count
  # ami                    = "ami-01e7ca2ef94a0ae86" # Ubuntu
  ami = var.ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.websg.id]

  user_data = <<-EOF
        #!/bin/bash
        echo "Hello, World - "`hostname` > index.html
        nohup busybox httpd -f -p 80 &
        EOF
  tags = {
    "Name" = "webserver-manju-${count.index + 1}"
  }
  # Key created manually in AWS Console
  key_name = "manju-key"

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ipaddress.txt"
  }
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> ipaddress.txt"
  }

  provisioner "file" {
    source      = "listing.sh"
    destination = "/tmp/listing.sh"
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("./manju-key.pem")
    }
  }


  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/listing.sh",
      "/tmp/listing.sh"
    ]
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("./manju-key.pem")
    }

  }

}

resource "aws_security_group" "websg" {
  name = "webservermanju"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "ipaddress" {
  value = aws_instance.webserver[*].public_ip
}

