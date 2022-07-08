provider "aws" {
  profile = var.owner_profile
  region  = var.owner_region
}

provider "aws" {
  alias = "accepter"
  region  = var.accepter_region
  profile = var.accepter_profile
}
