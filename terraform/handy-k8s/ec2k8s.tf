resource "aws_instance" "ec2k8s" {
  ami           = "ami-0e45766c39d6d6e73"
  instance_type = "t2.large"

  associate_public_ip_address = true
  key_name                    = aws_key_pair.myssh-key.key_name

  vpc_security_group_ids = [aws_security_group.handyhello.id]
}
