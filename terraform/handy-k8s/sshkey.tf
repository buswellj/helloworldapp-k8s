resource "aws_key_pair" "myssh-key" {
  key_name   = "myssh-key"
  public_key = file(var.sshkeypath)
}
