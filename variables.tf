variable "aws_region" {
  default = "us-east-2"
}

variable "ami_id" {
  default = "ami-0c55b159cbfafe1f0" # Example Amazon Linux 2 AMI for us-east-2
}

variable "instance_type" {
  default = "t2.micro"
}
