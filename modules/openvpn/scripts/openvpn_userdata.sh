#!/bin/bash -vx
exec > >(tee /var/log/userdata.log)
exec 2>&1

INS_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`
apt-get update
apt-get install -y python-pip unzip libwww-perl libdatetime-perl

pip install awscli --upgrade

# Assosiate EIP
/usr/local/bin/aws ec2 associate-address --instance-id $INS_ID --allocation-id ${OpenVpnEIP_AllocationId} --region ${Aws_Region}

# Change password to the one we generated in SSM
service openvpnas stop
echo  "${OpenVpnAdminUser}:${OpenVpnAdminPassword}"| chpasswd

# Get backup if exists
OpenVPN_Backup_Exists=`/usr/local/bin/aws s3 ls s3://${OpenvpnBackupBucket}/backups/openvpn/`
if [[ ! -z $OpenVPN_Backup_Exists ]];then
  echo "Found backup in s3://${OpenvpnBackupBucket}/backups/openvpn/...Restoring"
   /usr/local/bin/aws --region ${Aws_Region} s3 cp --recursive s3://${OpenvpnBackupBucket}/backups/openvpn/etc/ /usr/local/openvpn_as/etc/
else
  echo "Did not find backup under s3://${OpenvpnBackupBucket}/backups/openvpn/"
fi

service openvpnas start
/usr/local/openvpn_as/scripts/confdba -m --prof Default -k vpn.server.routing.private_network.0 -v ${Vpc_Cidr}
/usr/local/openvpn_as/scripts/confdba -m --prof Default -k host.name -v ${OpenVpnEIP}

service openvpnas restart
