terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "~> 4.1"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.23"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.63"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.30"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.21"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    remote = {
      source  = "tenstad/remote"
      version = "~> 0.1"
    }
  }
  backend "s3" {
    bucket         = "kendops-rke2-manager-state"
    key            = "donald-rke2-downstream-dev.tfstate"
    region         = "us-east-2"
    dynamodb_table = "kendops-rke2-manager-state" # Optional, remove this line if you don't want to use locking
    # encrypt        = true
  }
}

