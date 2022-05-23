# provider "aws" {
#   region     = "us-east-2"
#   access_key = "AKIASIOJN5QTP6DTFEL7"
#   secret_key = "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"
# }

# resource "aws_iam_role" "lambda-role" {
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "lambda.amazonaws.com"
#         }
#       },
#     ]
#   })
#     tags = {
#     Name = "lambda-ec2-role"
#   }
# }

# resource "aws_iam_policy" "lambda-policy" {
#   name = "lambda-ec2-stop-start"

#   policy = jsonencode({
#     Version = "2012-10-17"
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "logs:CreateLogGroup",
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ],
#       "Resource": "arn:aws:logs:*:*:*"
#     },
#     {
#       "Effect": "Allow",
#       "Action": [
#         "ec2:DescribeInstances",
#         "ec2:DescribeRegions",
#         "ec2:StartInstances",
#         "ec2:StopInstances"
#       ],
#       "Resource": "*"
#     }
#   ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda-ec2-policy-attach" {
#   policy_arn = aws_iam_policy.lambda-policy.arn
#   role = aws_iam_role.lambda-role.name
# }

# resource "aws_lambda_function" "ec2-stop-start" {
#   filename      = "lambda.zip"
#   function_name = "lambda"
#   role          = aws_iam_role.lambda-role.arn
#   handler       = "lambda.lambda_handler"


#   source_code_hash = filebase64sha256("lambda.zip")

#   runtime = "python3.7"
#   timeout = 63
# }

# resource "aws_cloudwatch_event_rule" "ec2-rule" {
#   name        = "ec2-rule"
#   description = "Trigger Stop Instance every 11:30 to 6am "
#   #schedule_expression = "rate(5 minutes)"
#    schedule_expression ="cron( 30 23 * * * )" "cron(0 6 * * *)"
#    count = 2
# }

# resource "aws_cloudwatch_event_target" "lambda-func" {
#   rule      = aws_cloudwatch_event_rule.ec2-rule.name
#   target_id = "lambda"
#   arn       = aws_lambda_function.ec2-stop-start.arn
# }

# resource "aws_lambda_permission" "allow_cloudwatch" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.ec2-stop-start.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_event_rule.ec2-rule.arn
# }


# resource "tls_private_key" "this" {
#   algorithm = "RSA"
#   rsa_bits  = 2048

# }

# resource "aws_key_pair" "mykey-1" {
#   key_name   = "terraform-key"
#   public_key = tls_private_key.this.public_key_openssh
# }
# resource "aws_security_group" "allow_tls" {
#   name        = "allow_tls"
#   description = "Allow TLS inbound traffic"


#   ingress {

#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]

#   }
#   ingress {

#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]

#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]

#   }

#   tags = {
#     Name = "allow_tls"
#   }
# }

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["099720109477"] # Canonical
# }

# resource "aws_instance" "web" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"
#   tags = {
#     Name = "terraform-ami"
#   }

#   key_name               = aws_key_pair.mykey-1.key_name
#   vpc_security_group_ids = [aws_security_group.allow_tls.id]

#   user_data = <<EOF
# #!/bin/bash
# sudo apt update
# sudo apt install nginx

# EOF
# }