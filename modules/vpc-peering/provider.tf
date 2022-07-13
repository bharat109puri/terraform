provider "aws" {
  region = var.owner_region
}

provider "aws" {
  alias  = "accepter"
  region = var.accepter_region
}
