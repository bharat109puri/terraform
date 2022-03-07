# bootstrap

Terraform base resources which are not supposed to be changing frequently.

The outputs are used by other Terraform workspaces, you have to remove dependencies before you can remove resources here.

## Known issues

- Client VPN Endpoint creation is slow, subnet associations might time out.

## Further docs

- [Client VPN](client_vpn.md)
- [CloudTrail](cloudtrail.md)
