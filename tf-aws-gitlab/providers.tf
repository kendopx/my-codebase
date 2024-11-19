provider "aws" {
  region = var.region
}

####################################################

### Optional 
### For CloudFlare only 

####################################################

provider "cloudflare" {
  email = var.cloudflare_email
  # api_token = var.cloudflare_api_token
  api_key = var.cloudflare_api_key
}

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}

