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
    # NOTE: topology blocks must be kept in an alphabetical order based on `id


    topology {
      id         = "cold"
      zone_count = 2

      autoscaling {
        max_size = "15g"
      }
    }

    topology {
      id         = "hot_content"
      zone_count = 3

      autoscaling {
        max_size = "8g"
      }
    }

    topology {
      id         = "master"
      zone_count = 3
      size       = "4g"
    }


    topology {
      id         = "warm"
      zone_count = 3

      autoscaling {
        max_size = "15g"
      }
    }

    # topology {
    #   id         = "frozen"
    #   zone_count = 2

    #   autoscaling {
    #     max_size = "15g"
    #   }
    # }
  }

  kibana {
    config {
      user_settings_yaml = <<-EOT
            # Note that the syntax for user settings can change between major versions.
            # You might need to update these user settings before performing a major version upgrade.
            #
            # Use OpenStreetMap for tiles:
            # tilemap:
            #   options.maxZoom: 18
            #   url: http://a.tile.openstreetmap.org/{z}/{x}/{y}.png
            #
            # To learn more, see the documentation.
            #
            #
            # 2022-07-11
            # 00980943 - empty PDF and PNG reports generated from dashboard
            # https://support.elastic.co/cases/5008X000028STc4QAG
            xpack.reporting.capture.timeouts.openUrl: 300000
            xpack.reporting.capture.timeouts.waitForElements: 300000
            xpack.reporting.capture.timeouts.renderComplete: 300000
        EOT
    }
  }

  integrations_server {}

  enterprise_search {}

  ## added id as change was done manually
  traffic_filter = [
    ec_deployment_traffic_filter.this.id,
    "1ae1b6fc3f794f1680811284bda9ab3b",
    "2b89fafb4f934c65b916353fdf4c9d0f",
    "9fa7c72bb1d74136ab0222cb2ed842a8",
    "efc6a0ceb30b466798611896e3a6ea3a"
  ]

  # lifecycle {
  #   ignore_changes = [
  #     elasticsearch[0].topology
  #   ]
  # }
}
