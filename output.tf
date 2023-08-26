output "ec2-ip" {
  value = aws_eip.interface_eip.public_ip
}