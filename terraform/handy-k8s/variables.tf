variable "aws_region" {
  type        = string
  description = "AWS Region to use"
  default     = "us-east-2"
}

variable "aws_profile" {
  type        = string
  default     = "default"
}

variable "sshkeypath" {
  type        = string
  description = "SSH public key to install in AMI"
  default     = "~/.ssh/id_rsa.pub"
}

variable "mgmt_ip" {
  type = string
  default = "24.26.138.0/24"
}
