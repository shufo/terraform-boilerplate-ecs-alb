#!/bin/bash
yum install -y aws-cli epel-release jq
yum install --enablerepo=epel -y redis
aws s3 cp s3://${project}.${environment}.ecs/ecs.config /etc/ecs/ecs.config --region=${region}
aws s3 cp s3://${project}.${environment}.ecs/nginx.conf /nginx.conf --region=${region}
aws configure set preview.cloudfront true
