provider "rancher2" {
  access_key = data.hcp_vault_secrets_app.kendops-infra.secrets["rke2_dev_mgnr_rancher_access_key"]
  secret_key = data.hcp_vault_secrets_app.kendops-infra.secrets["rke2_dev_mgnr_rancher_secret_key"]
  api_url    = data.hcp_vault_secrets_app.kendops-infra.secrets["rke2_dev_mgnr_rancher_url"]

}

provider "github" {
  token = data.hcp_vault_secrets_app.kendops-infra.secrets["github_token"]
  #organization = "Your Organization" #for an enterprise account
  owner = "kendops"

}

provider "aws" {
  region     = "us-east-2"
  access_key = data.hcp_vault_secrets_app.kendops-infra.secrets["aws_admin_access_key"]
  secret_key = data.hcp_vault_secrets_app.kendops-infra.secrets["aws_admin_secret_key"]

}

provider "hcp" {
  client_id     = var.hcp_client_id
  client_secret = var.hcp_client_secret
}

# provider "helm" {
#   kubernetes {
#     config_path = local_file.get-kube.filename
#   }
# }

# provider "kubernetes" {
#   config_path = local_file.get-kube.filename
#   insecure    = true

# }

