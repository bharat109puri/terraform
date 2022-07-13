# openvpn Terraform Module

This folder has terraform templates to deploy openvpn in Shared Services VPC

## Module Inputs

This module takes the following inputs:

### Terraform Variables

|     Parameter    |            Description         |  
|------------------|--------------------------------|
|     openvpn_tags      |  Tags for openvpn server like Environment,BusinessUnit etc.  |
|     openvpn_asg_tags      |  Tags for openvpn ASG like BackupDisable,Environment etc. |
|     name_prefix      | Name prefix for openvpn |                  
|     openvpn_image_id      |  openvpn AMI ID, if not defined it will take from filter |
|     openvpn_instance_type      | openvpn instance type |
|     openvpn_key_name      |  openvpn key name |
|     openvpn_root_volume_type      |  openvpn root volume type like gp2" |
|     openvpn_root_volume_size      |  openvpn root volume size |
|     openvpn_ingress_allow_cidr_blocks      | openvpn ingress rule to allow IP's to access openvpn |
|     openvpn_max_size      |  openvpn ASG max size |
|     openvpn_min_size      |  openvpn ASG min size |
|     openvpn_desired_capacity      |  openvpn ASG desired size |
|     openvpn_user_data      |  openvpn userdata file path example "config/user_data.tpl" |
|     openvpn_public_subnets_ids      |  openvpn public subnet ID's |
|     aws_region      |  AWS region to deploy openvpn |


## How to Deploy


1.  Create S3 Bucket for state file.
2.  Use openvpn Apply Job or Apply Terraform Commands:

```bash
terraform init
terraform plan
terraform apply
```

## How to Destroy
 Use openvpn Destroy Job or manually Destroy Terraform AWS Resources:

```bash
terraform destroy
```

## Output

|     Output    |            Description         |  
|------------------|--------------------------------|
|    openvpn_elb_dns      |  openvpn ELB  dns end point to connect to openvpn server |
