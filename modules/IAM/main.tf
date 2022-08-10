
#assume role is the assume role

resource "aws_iam_role" "fargate_role" {
  name = "yak_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid      = "VisualEditor0",
        Effect   = "Allow",
        Action   = "ecr:*",
        Resource = "*"
      },

    ]
  })
}

resource "aws_iam_role_policy_attachment" "fargate_attachment" {
  role       = aws_iam_role.fargate_role.name
  policy_arn = aws_iam_policy.policy.arn
}





