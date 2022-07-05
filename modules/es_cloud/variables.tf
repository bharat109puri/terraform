variable "elastic_version" {
  description = "Elasticsearch version"
  type        = string
}

variable "name" {
  description = "Elastic Cloud deployment name"
  type        = string
}

variable "vpc_endpoint_id" {
  description = "Elastic VPC endpoint ID (output from `vpc_endpoint` submodule)"
  type        = string
}

variable "topology" {
  type = list(object({
    id = string
    zone_count = number
    autoscaling_max_size = string
  }))
  nullable = true
}