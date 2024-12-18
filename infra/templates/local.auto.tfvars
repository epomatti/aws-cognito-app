# Project
app_name = "wealthtech"

### Cognito ###
# User Pool
mfa_configuration            = "OPTIONAL" # ON, OFF, OPTIONAL
allow_admin_create_user_only = true

# App Client
callback_urls        = ["http://localhost:5000/", "http://localhost:5000/callback"]
logout_urls          = ["http://localhost:5000", "http://localhost:5000/logout"]
google_client_id     = ""
google_client_secret = ""
