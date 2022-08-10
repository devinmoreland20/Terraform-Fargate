
#assume role is the assume role

resource "aws_iam_role" "fargate_role" {
  name               = var.name
  assume_role_policy = var.assume_role_policy
}

resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  path        = var.path
  description = var.iam_policy_description

  policy = var.iam_policy
}

resource "aws_iam_role_policy_attachment" "fargate_attachment" {
  role       = aws_iam_role.fargate_role.name
  policy_arn = aws_iam_policy.policy.arn
}





