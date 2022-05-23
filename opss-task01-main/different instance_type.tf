resource "aws_instance" "Auto-Start" {
  count         = 2 # Here we are creating identical 2 machines. 
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "Auto-Start"
  }
  user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt install nginx
EOF

}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"


  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_tls"
  }
}
  