# AWS Cognito App

## 1 - Create the infrastructure

This will ramp-up a Cognito User Pool, domain and client application configured for this project.

Create the infrastructure variables file:

```sh
touch infra/.auto.tfvars
```

Add the variables according to your requirements:

```hcl
region        = "us-east-2"
callback_urls = ["http://localhost:5000/"]
```

Deploy the infrastructure:

```sh
terraform -chdir="infra" init
terraform -chdir="infra" apply -auto-approve
```

Use the output variables `cognito_client_id` and `cognito_oidc_issuer_endpoint` as input for the backend setup.

To get the client secret:

```sh
aws cognito-idp describe-user-pool-client --user-pool-id "<region>_xxxxxxxxx" --client-id "00000000000000000000000000"
```

## 2 - Create the backend

The backend will provide the authenticated resources using Cognito as the IdP.

Create the `.env` file:

```sh
touch backend/.env
```

Add the required OIDC variables to the `.env` file (copy from Cognito):

```sh
ISSUER_BASE_URL="https://cognito-idp.<region>.amazonaws.com/<user-pool>/"
CLIENT_ID="00000000000000000000000000"
BASE_URL="http://localhost:5000"
SECRET="000000000000000000000000000000000000000000000000000"
```

Start the application server:

```sh
yarn --cwd "./backend" install
yarn --cwd "./backend" dev
```


## 3 - Testing

1. Access the application login: http://localhost:5000/login
2. Create your account on cognito
3. You should be redirect to the application after authentication
4. Try accessing restricted data: http://localhost:5000/profile
4. Logout: http://localhost:5000/logout

---
### Clean up

Once ready, delete the infrastructure:

```sh
terraform -chdir="infra" destroy -auto-approve
```

## Reference

- [Auth0 Express quickstart](https://auth0.com/docs/quickstart/webapp/express)
- [OpenID Connect debugger](https://oidcdebugger.com/)
