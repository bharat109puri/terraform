Draft

Every microservice will create the following:

1. IAM role - example: staging-lena-micro-services-role
2. IAM policy associated with that role - example: staging-lena-micro-services-policy
3. service account in kubernetes cluster:
Command to validate that:
    kubectl get serviceaccounts
