# AWS Cognito App

## 1 - Create Google social account

Follow the steps to create a Google social account:

https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-social-idp.html

## 2 - Create the Cognito resources

This will ramp-up a Cognito User Pool, domain and client application configured for this project.

Create the Cognito variables file:

```sh
touch infra/.auto.tfvars
```

Add the variables according to your requirements:

```hcl
# Cognito
callback_urls = ["http://localhost:5000/", "http://localhost:5000/callback"]
logout_urls   = ["http://localhost:5000", "http://localhost:5000/logout"]

# Google
google_client_id     = ""
google_client_secret = ""
```

Deploy the infrastructure:

```sh
terraform -chdir="cognito" init
terraform -chdir="cognito" apply -auto-approve
```

Use the output variables `cognito_client_id` and `cognito_oidc_issuer_endpoint_url` as input for the backend setup.

To get the client secret:

```sh
aws cognito-idp describe-user-pool-client --user-pool-id "<region>_xxxxxxxxx" --client-id "00000000000000000000000000"
```

## 3 - Create the backend

The backend will provide the authenticated resources using Cognito as the IdP.

```sh
cd backend
```

Create the `.env` file:

```sh
touch .env
```

Add the required OIDC variables to the `.env` file (copy from Cognito):

```sh
ISSUER_BASE_URL="https://cognito-idp.<region>.amazonaws.com/<user-pool>/"
BASE_URL="http://localhost:5000"
CLIENT_ID="00000000000000000000000000"
CLIENT_SECRET="000000000000000000000000000000000000000000000000000"
SECRET="abcdef0123456789"
```

Start the application server:

```sh
yarn install
yarn dev
```

## 4 - Local Testing

1. Access the application login: http://localhost:5000/login
2. Create your account on cognito
3. You should be redirect to the application after authentication
4. Try accessing restricted data: http://localhost:5000/profile
4. Logout should be http://localhost:5000/logout but Cognito doesn't expose it in the issuer API, so build manually the URL like this: `https://<DOMAIN_PREFIX>.auth.<AWS_REGION>.amazoncognito.com/logout?client_id=0000000000000000000&logout_uri=http://localhost:5000/logout`

## 5 - Elastic Beanstalk

Optionally, deploy to an EB environment.

ℹ️ You'll need to activate HTTPS in order for Cognito to accept the callback URLs.

```sh
touch elasticbeanstalk/.auto.tfvars
```

Add the variables according to your requirements:

```hcl
region             = "us-east-2"
ec2_instance_types = "t2.micro"
client_id          = "00000000000000000000000000"
client_secret      = "0000000000000000000000000000000000000000000000000000"
secret             = "abcdef0123456789"
issuer_base_url    = "https://cognito-idp.<region>.amazonaws.com/<user-pool-id>"
```

Deploy the infrastructure:

```sh
terraform -chdir="elasticbeanstalk" init
terraform -chdir="elasticbeanstalk" apply -auto-approve
```

At this point, configure HTTPS in Elastic Beanstalk.

➡️ Set the Elastic Beanstalk application URL as `BASE_URL` environment variable in EB that must have HTTPS.

➡️ Set the Elastic Beanstalk application URL as a callback URL in Cognito that must have HTTPS.

Deploy the code to Elastic Beanstalk.

---
### Clean up

Once ready, delete the infrastructure:

```sh
terraform -chdir="cognito" destroy -auto-approve
terraform -chdir="elasticbeanstalk" destroy -auto-approve
```

Also delete the Google credentials and authorization.

## Reference

- [Auth0 Express quickstart](https://auth0.com/docs/quickstart/webapp/express)
- [OpenID Connect debugger](https://oidcdebugger.com/)
- [Cognito logout example](https://rieckpil.de/oidc-logout-with-aws-cognito-and-spring-security/)
- [Add social identity provider](https://docs.aws.amazon.com/cognito/latest/developerguide/cognito-user-pools-social-idp.html)
