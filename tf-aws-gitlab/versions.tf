terraform {
  required_version = ">= 1.0.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.23"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.73.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.8"
    }
  }
}



