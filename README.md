# terraform-boilerplate-ecs-alb

[Terraform](https://www.terraform.io/) boilerplate for  [ECS](https://aws.amazon.com/ecs/?nc2=h_l3_c) with [ALB](https://aws.amazon.com/elasticloadbalancing/applicationloadbalancer/?nc1=h_ls).

## Features

- Separated configuration per environment
- Terraform v0.7.0 compatible
- S3 backed [remote state](https://www.terraform.io/docs/state/remote/index.html)
- ECS with ALB
- Deliver assets by S3 + CloudFront
- RDS (MySQL)
- ElastiCache (Redis)
- Separated subnets per environment
- Store ALB logs to S3
- Automatic ECS-Optimized AMI update by [data resource](https://www.terraform.io/docs/configuration/data-sources.html)
- Centeralized Container Logs with CloudWatch Logs (production)

## Resources

- ALB
- CloudFront
- EC2
- ECS
- ElastiCache (Redis)
- IAM
- RDS (MySQL)
- Route53
- S3
- Security Group
- VPC

## Installation

### Root directory

- Edit variables

`variables.tf`

```hcl
# A project name
variable "project" {
  default = "example"
}

# AWS Region
variable "region" {
  default = "ap-northeast-1" # replace with your region
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
```

- Create bucket for remote state

```bash
aws s3 mb s3://example.terraform
```


- Set S3 remote state

```bash
terraform remote config \
    -backend=s3 \
    -backend-config="bucket=example.terraform" \
    -backend-config="key=example.super.terraform.tfstate" \
    -backend-config="region=us-east-1"
```

### Development

- Change directory

```
cd development
```

- Edit variables

`development/variables.tf`

```hcl
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
```

- Set S3 remote state

```bash
terraform remote config \
    -backend=s3 \
    -backend-config="bucket=example.terraform" \
    -backend-config="key=example.development.terraform.tfstate" \
    -backend-config="region=us-east-1"
```

### Production

- Change directory

```
cd production
```

- Edit variables

`production/variables.tf`

```hcl
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
  default = "production"
}

# S3 bucket to use tfstate remote store
variable "tf_state_bucket" {
  default = "example.terraform"
}

# Key name for super state file
variable "tf_state_key_super" {
  default = "example.super.terraform.tfstate"
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

```

- Set S3 remote state

```bash
terraform remote config \
    -backend=s3 \
    -backend-config="bucket=example.terraform" \
    -backend-config="key=example.production.terraform.tfstate" \
    -backend-config="region=us-east-1"
```

## Usage

- Apply

Global resources (IAM, Route53, S3, VPC, etc...)

```
terraform plan
terraform apply
```

  - development

  ```
  cd development
  terraform plan
  terraform apply
  ```

  - production

  ```
  cd production
  terraform plan
  terraform apply
  ```

States are automatically synced with remote S3 bucket, so you can work with team member and integrate terraform continuously by your continuous integration tools.


- Destroy

```bash
# Destroy each environment
$ cd development
$ terraform destroy
$ cd production
$ terraform destroy
# Finally destroy global resources
$ terraform destroy
```

## Motivation

Most of terraform problem is where to store tfstate, or how can I switch tfstate per environment.  
So I decided to separate directory and pass the data between environment by `data` resource rather than manage all environment in a one directory and switch configuration by vars files.

It consist with a root directory and  per environment directories.  
This comes terraform operation more easily and safely that each environment is separated in a file system level.
