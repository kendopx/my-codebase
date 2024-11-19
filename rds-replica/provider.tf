################################################################################
# RDS AZ Replication Module
# Create AWS RDS cluster using terraform with Cross-Region replication
################################################################################

provider "aws" {
  region = "us-east-1"
}

# Provider for Read Replica
provider "aws" {
  region = "us-west-1"
  alias  = "replica"
}

