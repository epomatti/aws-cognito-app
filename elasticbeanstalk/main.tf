terraform {
  backend "local" {
    path = ".workspace/terraform.tfstate"
  }
}

provider "aws" {
  region = var.region
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
    value     = var.issuer_base_url
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CLIENT_ID"
    value     = var.client_id
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "CLIENT_SECRET"
    value     = var.client_secret
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SECRET"
    value     = var.secret
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
