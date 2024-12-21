# Project
app_name = "wealthtech"

### Cognito ###

# User Pool
mfa_configuration            = "OFF"                     # ON, OFF, OPTIONAL
username_attributes          = ["email", "phone_number"] # "email", "phone_number"
auto_verified_attributes     = ["email"]                 # "email", "phone_number"
allow_admin_create_user_only = true

# User Pool: Password policy
minimum_length                   = 8
require_lowercase                = true
require_numbers                  = true
require_symbols                  = true
require_uppercase                = true
temporary_password_validity_days = 7
password_history_size            = 0 # A value of 0 means that password history is not enforced.

# App Client
callback_urls        = ["http://localhost:5000/", "http://localhost:5000/callback"]
logout_urls          = ["http://localhost:5000", "http://localhost:5000/logout"]
google_client_id     = ""
google_client_secret = ""
