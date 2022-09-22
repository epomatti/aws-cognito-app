terraform {
  backend "local" {
    path = ".workspace/terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
}


# TODO: Verify attribute changes
resource "aws_cognito_user_pool" "main" {
  name = "mypool"
  // alias_attributes         = ["email"]
  username_attributes      = ["email"]
  mfa_configuration        = "OFF"
  auto_verified_attributes = ["email"]

  admin_create_user_config {
    # Enable self-registration
    allow_admin_create_user_only = false
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  # This will add email as a required attribute
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
}

resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.main.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "email"
    client_id        = var.google_client_id
    client_secret    = var.google_client_secret
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = var.domain
  user_pool_id = aws_cognito_user_pool.main.id
}

resource "aws_cognito_user_pool_client" "main" {
  name                                 = "client-app"
  user_pool_id                         = aws_cognito_user_pool.main.id
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  allowed_oauth_flows_user_pool_client = true
  # explicit_auth_flows = [
  #   "ALLOW_REFRESH_TOKEN_AUTH",
  #   "ALLOW_USER_SRP_AUTH",
  # ]
  generate_secret              = true
  allowed_oauth_flows          = ["code"]
  allowed_oauth_scopes         = ["email", "openid", "profile"]
  supported_identity_providers = ["COGNITO", aws_cognito_identity_provider.google.provider_name]

  # To make it easy during development
  lifecycle {
    ignore_changes = [
      callback_urls, logout_urls
    ]
  }
}


### Permissions ###

resource "aws_iam_role" "main" {
  name = "app-test-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkWebTier" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkWorkerTier" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkMulticontainerDocker" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "main" {
  name = "beanstalk-test-profile"
  role = aws_iam_role.main.id

  depends_on = [
    aws_iam_role_policy_attachment.AWSElasticBeanstalkWebTier,
    aws_iam_role_policy_attachment.AWSElasticBeanstalkWorkerTier,
    aws_iam_role_policy_attachment.AWSElasticBeanstalkMulticontainerDocker,
    aws_iam_role_policy_attachment.AmazonSSMManagedInstanceCore
  ]
}


### Elastic Beanstalk ###

resource "aws_key_pair" "beanstalk_worker_key" {
  key_name   = "beanstalk-worker-key"
  public_key = file("${path.module}/keys/id_rsa.pub")
}

resource "aws_elastic_beanstalk_application" "main" {
  name        = "myapp"
  description = "Web app integrated with Cognito"
}

resource "aws_elastic_beanstalk_environment" "main" {
  name                = "long-running-environment"
  application         = aws_elastic_beanstalk_application.main.name
  solution_stack_name = "64bit Amazon Linux 2 v5.5.6 running Node.js 16"
  tier                = "WebServer"

  // Settings
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.main.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = aws_key_pair.beanstalk_worker_key.key_name
  }

  # setting {
  #   namespace = "aws:ec2:vpc"
  #   name      = "VPCId"
  #   value     = aws_vpc.main.id
  # }

  # setting {
  #   namespace = "aws:ec2:vpc"
  #   name      = "Subnets"
  #   value     = "${aws_subnet.a.id},${aws_subnet.b.id},${aws_subnet.c.id}"
  # }

  // Environment
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    // TODO: Create dedicated role?
    value = "aws-elasticbeanstalk-service-role"
  }

  // EC2
  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = var.ec2_instance_types
  }

  // Application
  setting {
    namespace = "aws:elasticbeanstalk:application"
    name      = "Application Healthcheck URL"
    value     = "/health"
  }

  // Environment Properties
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "ISSUER_BASE_URL"
    value     = "https://${aws_cognito_user_pool.main.endpoint}"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CLIENT_ID"
    value     = aws_cognito_user_pool_client.main.id
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SECRET"
    value     = aws_cognito_user_pool_client.main.client_secret
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "BASE_URL"
    value     = "http://localhost:5000"
  }

  // CloudWatch Logs
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "DeleteOnTerminate"
    value     = "true"
  }

  // Health Check
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs:health"
    name      = "HealthStreamingEnabled"
    value     = "true"
  }
}


### Outputs ###

output "cognito_oidc_issuer_endpoint" {
  value       = aws_cognito_user_pool.main.endpoint
  description = "This is the OIDC Issuer endpoint"
}

output "cognito_client_id" {
  value = aws_cognito_user_pool_client.main.id
}
