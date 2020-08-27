output "instance_ip" {
  value = aws_instance.ec2k8s.public_ip
}
