variable "astra_token" {
  description = "DataStax Astra API Administrator Service Account token"
  type        = string
  sensitive   = true
  default     = "AstraCS:LEUCshQGwMZSmycmGdELTuDQ:5c010f96654e44230c8c228b20ae58b9f201b2e3419c9b46f9845955dcac7755"
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "tfe_token" {
  description = "Terraform Cloud Team token"
  type        = string
  sensitive   = true
  default     = "SynI2fjDrXCngw.atlasv1.J7n4SYfp81d0ADdxj0lKbuiFtUL2fb9R2neMgIXDJT5QPezPjgnoA5NsT2xfzXJYwrU"
}
