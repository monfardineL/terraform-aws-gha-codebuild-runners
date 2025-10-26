resource "aws_iam_role" "codebuild_service_role" {
  count = var.create_iam_policy ? 1 : 0

  name = "codebuild-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_service_policy" {
  count = var.create_iam_policy ? 1 : 0

  name = "codebuild-gha-service-policy"
  role = aws_iam_role.codebuild_service_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "acm:*",
          "application-autoscaling:*",
          "athena:*",
          "autoscaling:*",
          "ce:*",
          "cloudformation:*",
          "cloudfront:*",
          "cloudtrail:*",
          "cloudwatch:*",
          "codebuild:*",
          "codecommit:*",
          "codeconnections:*",
          "codedeploy:*",
          "codepipeline:*",
          "cognito-idp:*",
          "cognito-identity:*",
          "comprehend:*",
          "config:*",
          "cur:*",
          "docdb-elastic:*",
          "dynamodb:*",
          "ebs:*",
          "ec2:*",
          "ecs:*",
          "eks:*",
          "elasticache:*",
          "elasticbeanstalk:*",
          "elasticfilesystem:*",
          "elasticloadbalancing:*",
          "elasticmapreduce:*",
          "events:*",
          "glacier:*",
          "glue:*",
          "iam:*",
          "kinesis:*",
          "kms:*",
          "lambda:*",
          "logs:*",
          "neptune-db:*",
          "rds:*",
          "redshift:*",
          "rekognition:*",
          "resource-groups:*",
          "route53:*",
          "s3:*",
          "s3-object-lambda:*",
          "sagemaker:*",
          "secretsmanager:*",
          "shield:*",
          "sns:*",
          "sqs:*",
          "ssm:*",
          "states:*",
          "trustedadvisor:*",
          "vpce:*",
          "waf:*",
          "wafv2:*",
          "xray:*"
        ]
        Resource = "*"
      }
    ]
  })
}
