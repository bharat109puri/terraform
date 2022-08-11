# vim: set filetype=hcl
region          = "eu-west-1"
elastic_name    = "staging"
elastic_version = "8.3.3"
topology = [
  # {
  #   id                   = "cold"
  #   zone_count           = 2
  #   autoscaling_max_size = "15g"
  # },
  # {
  #   id                   = "frozen"
  #   zone_count           = 2
  #   autoscaling_max_size = "15g"
  # },
  {
    id                   = "hot_content"
    zone_count           = 1
    size                 = "2g"
    autoscaling_max_size = "8g"
  }
  # {
  #   id                   = "warm"
  #   zone_count           = 3
  #   autoscaling_max_size = "15g"
  # }
]