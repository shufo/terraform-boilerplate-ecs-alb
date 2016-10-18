# A project name
variable "project" {
  default = "example"
}

# AWS Region
variable "region" {
  default = "ap-northeast-1" # replace with your region
}

# Environment name
variable "environment" {
  default = "development"
}

# S3 bucket to use tfstate remote store
variable "tf_state_bucket" {
  default = "example.terraform"
}

# Key name for super state file
variable "tf_state_key_super" {
  default = "example.super.terraform.tfstate"
}

# aws provider setting
provider "aws" {
  region = "${var.region}"
}

# AWS Account ID
variable "aws_account_id" {
  default = "123456789012" # replace with your aws account id
}

# Route53 root zone
variable "route53_zone" {
  default = "example.com" # replace with your domain
}

# Docker repository name for app container on ECS
variable "docker_repository" {
  default = "namespace/image_name"
}

# ECS Authentication data
variable "ecs_auth_data" {
  # Replace with your DockerHub credentials
  default = "{\"https://index.docker.io/v1/\":{\"auth\":\"foobar\",\"email\":\"example@example.com\"}}"
}
