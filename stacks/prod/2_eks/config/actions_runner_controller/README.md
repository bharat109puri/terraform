# actions-runner-controller

https://github.com/actions-runner-controller/actions-runner-controller

Hosting our own GitHub Actions runners allows us to use ServiceAccounts and [IRSA][] instead of long-living API keys on GitHub.

[IRSA]: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html

## Dependencies

This workspace depends on cert-manager and SealedSecrets. Both are managed in separete workspaces.
