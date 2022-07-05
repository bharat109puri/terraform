data "aws_region" "current" {}

resource "ec_deployment_traffic_filter" "this" {
  name   = "Traffic Filter for ${var.name}"
  region = data.aws_region.current.name
  type   = "vpce"

  rule {
    source = var.vpc_endpoint_id
  }
}

resource "ec_deployment" "this" {
  name = var.name

  region  = data.aws_region.current.name
  version = var.elastic_version

  # NOTE: https://www.elastic.co/guide/en/cloud/current/ec-regions-templates-instances.html#ec-aws_regions
  # NOTE: Ideal for ingestion use cases with more than 10 days of data available for fast access. Also good for light search use cases with very large data sets.
  deployment_template_id = "aws-storage-optimized-dense"

  elasticsearch {
    # NOTE: Each Elasticsearch data tier SCALES UPWARD based on the amount of available storage
    # NOTE: When it detects more storage is needed, autoscaling will scale up EACH DATA TIER INDEPENDENTLY
    autoscale = "true"

    # NOTE: https://github.com/elastic/terraform-provider-ec/issues/336
    # NOTE: topology blocks must be kept in an alphabetical order based on `id`
  

    dynamic "topology" {
      for_each = var.topology
      content {
       id = settings.value["id"]
       zone_count = settings.value["zone_count"]
        autoscaling {
          max_size = settings.value["max_size"]
        }
      }
    }

    # topology {
    #   id         = "cold"
    #   zone_count = 2

    #   autoscaling {
    #     max_size = "15g"
    #   }
    # }

    # topology {
    #   id         = "frozen"
    #   zone_count = 2

    #   autoscaling {
    #     max_size = "15g"
    #   }
    # }

    # topology {
    #   id         = "hot_content"
    #   zone_count = 3

    #   autoscaling {
    #     max_size = "8g"
    #   }
    # }

    # topology {
    #   id         = "warm"
    #   zone_count = 3

    #   autoscaling {
    #     max_size = "15g"
    #   }
    # }
  }

  kibana {}

  integrations_server {}

  enterprise_search {}

  traffic_filter = [
    ec_deployment_traffic_filter.this.id
  ]

  lifecycle {
    ignore_changes = [
      elasticsearch[0].topology
    ]
  }
}
