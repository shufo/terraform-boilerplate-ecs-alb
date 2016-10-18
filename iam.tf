/**
 * IAM group for project developers
 */
resource "aws_iam_group" "developers" {
    name = "${var.project}-developers"
    path = "/${var.project}/"
}

/**
 * Membership of developers group
 */
resource "aws_iam_group_membership" "developers" {
    name = "${var.project}-developers-group-membership"
    users = [
    ]
    group = "${aws_iam_group.developers.name}"
}

/**
 * Group policy for developers group
 */
resource "aws_iam_group_policy" "developers_policy" {
    name = "${var.project}_developer_policy"
    group = "${aws_iam_group.developers.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject",
        "s3:PutObjectAcl",
        "s3:GetObjectAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${var.project}.*/*"
      ]
    }
  ]
}
EOF
}

/**
 * IAM group for administrators
 */
resource "aws_iam_group" "administrators" {
    name = "${var.project}-administrators"
    path = "/${var.project}/"
}

/**
 * CI user for project
 */
resource "aws_iam_user" "ci" {
    name = "${var.project}-ci"
}

/**
 * Access key for CI user
 */
resource "aws_iam_access_key" "ci" {
    user = "${aws_iam_user.ci.name}"
}

/**
 * Group membership of administrators
 */
resource "aws_iam_group_membership" "administrators" {
  name = "${var.project}-administrators-group-membership"
  users = [
    "${aws_iam_user.ci.name}",
  ]
  group = "${aws_iam_group.administrators.name}"
}

/**
 * Group policy of administrators
 */
resource "aws_iam_group_policy" "administrators_policy" {
    name = "example_admin_policy"
    group = "${aws_iam_group.administrators.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

/**
 * Instance profile for ecs instance
 */
resource "aws_iam_instance_profile" "instance_role" {
    name = "${var.project}_instance_role_profile"
    roles = ["${aws_iam_role.instance_role.name}"]
}

/**
 * IAM role for ecs instance
 */
resource "aws_iam_role" "instance_role" {
    name = "${var.project}_instance_role"
    path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": ["ec2.amazonaws.com", "ecs.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

/**
 * Role policy for ecs instance
 */
resource "aws_iam_role_policy" "instance_role_policy" {
    name = "${var.project}_instance_role_policy"
    role = "${aws_iam_role.instance_role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": "ecs:*",
      "Resource": "*"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets",
        "ec2:Describe*",
        "ec2:AuthorizeSecurityGroupIngress",
        "elasticache:Describe*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Stmt0123456789",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${var.project}*"
      ]
    },
    {
      "Sid": "",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "",
      "Action": [
        "route53:ListHostedZones",
        "route53:ListResourceRecordSets"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Sid": "",
      "Action": [
        "cloudfront:ListDistributions"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
