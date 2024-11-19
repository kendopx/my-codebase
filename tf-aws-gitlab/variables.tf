# AWS Region
variable "region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-2"
}

# AWS EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.large"
}

variable "ec2_count" {
  default = "1"
}

variable "ssh_key" {
  default = "web-key.pem"
}

variable "key_name" {
  default = "web-key"
}

variable "ssh_key_pair" {
  default = ""
  type    = string
}

variable "ssh_private_pair" {
  default = ""
  type    = string
}

variable "gitlab_domain" {
  default = "gitlab.emagetech.co"
}

####################################################

### Optional 
### For CloudFlare only 

####################################################


variable "hcp_client_id" {
  type        = string
  description = "vault-secret client id"
  default     = ""
}

variable "hcp_client_secret" {
  type        = string
  description = "vault client secret id"
  default     = ""
}

variable "cloudflare_api_key" {
  description = "value of the api_key"
  default     = ""
}

variable "cloudflare_api_token" {
  default = ""
}

variable "cloudflare_email" {
  default = ""
}

variable "domain" {
  default = ""
}


# variable "cloudflare_email" {
#   type        = string
#   description = "clouflare email address"
# }

# variable "cloudflare_api_token" {
#   type        = string
#   description = "cloudflare api token"
# }
