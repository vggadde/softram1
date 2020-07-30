variable "aws_region" {}
variable "aws_profile" {}
data "aws_availability_zones" "available" {}
variable "localip" {}
variable "vpc_cidr" {}
variable "cidrs" {
  type = map(string)
}
variable "key_name" {}
variable "public_key_path" {}
variable "dev_instance_type" {}
variable "dev_ami" {}
