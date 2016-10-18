# A project name
variable "project" {
  default = "example"
}

# AWS Region
variable "region" {
  default = "ap-northeast-1" # replace with your region
}

# aws provider setting
provider "aws" {
  region = "${var.region}"
}

# S3 bucket for tfstate
variable "tf_state_bucket" {
  default = "example.terraform"
}

# Key name for state file of development environment
variable "tf_state_key_development" {
  default = "example.development.terraform.tfstate"
}

# Key name for state file of production environment
variable "tf_state_key_production" {
  default = "example.production.terraform.tfstate"
}

# Route53 root zone
variable "route53_zone" {
  default = "example.com"
}
