# variables.tf
variable "access_key" {
  default = "your_accesskey_here"
}
variable "secret_key" {
  default = "your_secretkey_here+"
}
variable "region" {
  default = "us-east-1"
}
variable "availabilityZone" {
    type    = list(string)
  default = ["us-east-1a","us-east-1f", "us-east-1b"]
}
variable "instanceTenancy" {
  default = "default"
}
variable "dnsSupport" {
  default = true
}
variable "dnsHostNames" {
  default = true
}
variable "vpcCIDRblock" {
  default = "10.0.0.0/16"
}
variable "subnetCIDRblock" {
    type = list(string)
  default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
}
variable "destinationCIDRblock" {
  default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}
variable "egressCIDRblock" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}
variable "mapPublicIP" {
  default = true
}
variable "ec2AMI" {
  default = "ami-0323c3dd2da7fb37d"
}
# end of variables.tf