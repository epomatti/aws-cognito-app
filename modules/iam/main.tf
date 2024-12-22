resource "random_uuid" "cognito_sms_external_id" {
}

# https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-sms-settings.html
# TODO: Add security (SourceAccount, SourceArn)
resource "aws_iam_role" "cognito_sms" {
  name = "WealthTechCognitoSMSCaller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cognito-idp.amazonaws.com"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "sts:ExternalId" : "${random_uuid.cognito_sms_external_id.result}",
          }
        }
      }
    ]
  })
}

# TODO: Reduce the permissions
resource "aws_iam_role_policy" "cognito_sms" {
  name = "WealthTechCognitoSMSCallerPolicy"
  role = aws_iam_role.cognito_sms.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sns:publish"
        ],
        Resource = [
          "*"
        ]
      }
    ]
  })
}
