locals {
  # NOTE: https://www.elastic.co/guide/en/cloud/current/ec-traffic-filtering-vpc.html#ec-private-link-service-names-aliases
  elastic_private_link_endpoints = {
    af-south-1 = {
      service_name = "com.amazonaws.vpce.af-south-1.vpce-svc-0d3d7b74f60a6c32c"
      domain_name  = "vpce.af-south-1.aws.elastic-cloud.com"
    }

    ap-east-1 = {
      service_name = "com.amazonaws.vpce.ap-east-1.vpce-svc-0f96fbfaf55558d5c"
      domain_name  = "vpce.ap-east-1.aws.elastic-cloud.com"
    }

    ap-northeast-1 = {
      service_name = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-0e1046d7b48d5cf5f"
      domain_name  = "vpce.ap-northeast-1.aws.elastic-cloud.com"
    }

    ap-northeast-2 = {
      service_name = "com.amazonaws.vpce.ap-northeast-2.vpce-svc-0d90cf62dae682b84"
      domain_name  = "vpce.ap-northeast-2.aws.elastic-cloud.com"
    }

    ap-south-1 = {
      service_name = "com.amazonaws.vpce.ap-south-1.vpce-svc-0e9c1ae5caa269d1b"
      domain_name  = "vpce.ap-south-1.aws.elastic-cloud.com"
    }

    ap-southeast-1 = {
      service_name = "com.amazonaws.vpce.ap-southeast-1.vpce-svc-0cbc6cb9bdb683a95"
      domain_name  = "vpce.ap-southeast-1.aws.elastic-cloud.com"
    }

    ap-southeast-2 = {
      service_name = "com.amazonaws.vpce.ap-southeast-2.vpce-svc-0cde7432c1436ef13"
      domain_name  = "vpce.ap-southeast-2.aws.elastic-cloud.com"
    }

    ca-central-1 = {
      service_name = "com.amazonaws.vpce.ca-central-1.vpce-svc-0d3e69dd6dd336c28"
      domain_name  = "vpce.ca-central-1.aws.elastic-cloud.com"
    }

    eu-central-1 = {
      service_name = "com.amazonaws.vpce.eu-central-1.vpce-svc-081b2960e915a0861"
      domain_name  = "vpce.eu-central-1.aws.elastic-cloud.com"
    }

    eu-south-1 = {
      service_name = "com.amazonaws.vpce.eu-south-1.vpce-svc-03d8fc8a66a755237"
      domain_name  = "vpce.eu-south-1.aws.elastic-cloud.com"
    }

    eu-west-1 = {
      service_name = "com.amazonaws.vpce.eu-west-1.vpce-svc-01f2afe87944eb12b"
      domain_name  = "vpce.eu-west-1.aws.elastic-cloud.com"
    }

    eu-west-2 = {
      service_name = "com.amazonaws.vpce.eu-west-2.vpce-svc-0e42a2c194c97a1d0"
      domain_name  = "vpce.eu-west-2.aws.elastic-cloud.com"
    }

    eu-west-3 = {
      service_name = "com.amazonaws.vpce.eu-west-3.vpce-svc-0d6912d10db9693d1"
      domain_name  = "vpce.eu-west-3.aws.elastic-cloud.com"
    }

    me-south-1 = {
      service_name = "com.amazonaws.vpce.me-south-1.vpce-svc-0381de3eb670dcb48"
      domain_name  = "vpce.me-south-1.aws.elastic-cloud.com"
    }

    sa-east-1 = {
      service_name = "com.amazonaws.vpce.sa-east-1.vpce-svc-0b2dbce7e04dae763"
      domain_name  = "vpce.sa-east-1.aws.elastic-cloud.com"
    }

    us-east-1 = {
      service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-0e42e1e06ed010238"
      domain_name  = "vpce.us-east-1.aws.elastic-cloud.com"
    }

    us-east-2 = {
      service_name = "com.amazonaws.vpce.us-east-2.vpce-svc-02d187d2849ffb478"
      domain_name  = "vpce.us-east-2.aws.elastic-cloud.com"
    }

    us-west-1 = {
      service_name = "com.amazonaws.vpce.us-west-1.vpce-svc-00def4a16a26cb1b4"
      domain_name  = "vpce.us-west-1.aws.elastic-cloud.com"
    }

    us-west-2 = {
      service_name = "com.amazonaws.vpce.us-west-2.vpce-svc-0e69febae1fb91870"
      domain_name  = "vpce.us-west-2.aws.elastic-cloud.com"
    }
  }
}
