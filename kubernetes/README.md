# Kubernetes

https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html

## Advanced pod networking

> You can implement a network segmentation and tenant isolation network policy. Network policies are similar to AWS security groups in that you can create network ingress and egress rules. Instead of assigning instances to a security group, you assign network policies to pods using pod selectors and labels. For more information, see [Installing Calico on Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/calico.html).

> Security groups for pods integrate Amazon EC2 security groups with Kubernetes pods. - https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html

---

- If you're going to deploy a cluster that uses the IPv4 family, we recommend creating small (/28), dedicated subnets for Amazon EKS created network interfaces, and only specifying these subnets as part of cluster creation. Other resources, such as nodes and load balancers, should be launched in separate subnets from the subnets specified during cluster creation.
- Subnets associated with your cluster cannot be changed after cluster creation. If you need to control exactly which subnets the Amazon EKS created network interfaces are placed in, then specify only two subnets during cluster creation, each in a different Availability Zone.
- Subnets do not require any tags for nodes. For Kubernetes load balancing auto discovery to work, subnets must be tagged as described in Subnet tagging.
- An updated range caused by adding CIDR blocks to an existing cluster can take as long as five hours to appear.

## Bottlerocket

https://aws.amazon.com/bottlerocket/faqs/

## Instance refresh

Setting `instance_refresh_enabled = true` will recreate your worker nodes without draining them first. It is recommended to install [aws-node-termination-handler](https://github.com/aws/aws-node-termination-handler) for proper node draining. See the [instance_refresh](https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples/irsa_autoscale_refresh) example provided.

## readonly role permissions

`readonly` user can't read the EKS cluster details.

## kubeconfig.yaml

```shell
aws-vault exec recrd/admin -- aws eks update-kubeconfig --name prod-kubernetes --dry-run > kubeconfig.yaml
```
