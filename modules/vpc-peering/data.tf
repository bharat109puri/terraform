data "aws_vpc" "accepter" {
    provider = "aws.accepter"
    id = var.accepter_vpc_id
}
data "aws_vpc" "owner" {
    id = var.owner_vpc_id
}


data "aws_route_tables" "accepter" {
  provider = "aws.accepter"
  vpc_id = data.aws_vpc.accepter.id
}

data "aws_route_tables" "owner" {
  vpc_id = var.owner_vpc_id
}
