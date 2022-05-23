output "Auto-Start" {
  # Here * indicates that there are more than one arn because count is 2   
  value = aws_instance.Auto-Start.*.arn
}