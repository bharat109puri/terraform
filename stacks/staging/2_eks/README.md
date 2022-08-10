# Kubernetes

https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html

## How to run `kubectl` commands?

Currently to run any `kubectl` command you have to:
- be on the [Recrd client VPN][]
- assume the `admin` IAM role ([aws-vault][] is recommended)
- use a compatible [kubectl][] version (`1.20-1.22`)
- use the checked-in [kubeconfig.yaml][] file

[Recrd client VPN]: ../bootstrap/client_vpn.md
[aws-vault]: https://github.com/99designs/aws-vault
[kubeconfig.yaml]: ./kubeconfig.yaml
[kubectl]: https://kubernetes.io/docs/tasks/tools/#kubectl

### `kubectl get pods` example

Connect to the VPN.

```shell
# Use PATH to kubeconfig.yaml
export KUBECONFIG=~/git/recrd/terraform/kubernetes/kubeconfig.yaml
# Assume `developer` role and run your `kubectl` command
aws-vault exec recrd/developer -- kubectl get pods
```

Managing sensitive and critical resources requires using the `recrd/admin` role.

### kustomize examples

By convention various Recrd projects have `k8s/` subdirectories.

These directories hold [kustomize][] configurations.
As a version of `kustomize` is always included in `kubectl` there's no need to install `kustomize` separately.

[kustomize]: https://github.com/RecrdGroup/kustomize

#### Check changes

```shell
aws-vault exec recrd/developer -- kubectl diff -k k8s/
```

If there's a change `developer` is not allowed to make, diff is going to fail.

#### Apply manifests

```shell
aws-vault exec recrd/developer -- kubectl apply -k k8s/
```

#### Secret management

Secrets must not be checked into version control.

SealedSecrets are safe to check in as they are encrypted.

For details on secret management see the [example][secret_management] in the kustomize repo.

[secret_management]: https://github.com/RecrdGroup/kustomize/blob/master/example/hello-world/README.md

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
aws-vault exec recrd/developer -- aws eks update-kubeconfig --name staging-kubernetes --dry-run > kubeconfig.yaml
```
