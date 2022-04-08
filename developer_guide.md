# Developer guide

The scope of this guide is to provide a very high level of understanding of patterns being established and to help developers around the various pieces of infrastructure code and deployment tools/pipelines.

It's not a definitive guide, it's not ready and please speak up if you have a better idea.

## Kubernetes cheat sheet

What?                                  | How?
---------------------------------------|--------------------------------------------------------------------------------
Read logs                              | `aws-vault exec recrd/developer -- kubectl logs --follow --selector=app=danube`
Restart all pods within the deployment | `aws-vault exec recrd/developer -- kubectl rollout restart deployment danube`
Check diff between code and state      | `aws-vault exec recrd/developer -- kubectl diff -k k8s/`
Apply application deployment changes   | `aws-vault exec recrd/developer -- kubectl apply -k k8s/`

## Application repo layout

[RecrdGroup/hello-world][] is an example repository showcasing where infrastructure code should be located.
It's getting updated irregularly, check on it time-to-time.

[RecrdGroup/hello-world]: https://github.com/RecrdGroup/hello-world

### `./terraform/`

If the application has special dependencies, then it should be managed from the application repository's `terraform` subdirectory.
Managing the dependencies here allows us in the future to update this Terraform configuration as part of the application's pipeline,
independently from the rest of the Terraform configuration.

### `./k8s/`

The applications should be packaged to be able to be deployed onto AWS Elastic Kubernetes Service (EKS).

The related configuration should be living inside the application repository's `k8s` subdirectory.
These Kubernetes manifests are expected to be very similar, this allows us the future to simplify the deployment pipelines
and to roll out changes across all applications easily.

By keeping the configuration simple, you can help these efforts.

## How to build container images from Spring Boot projects

In 99% of the cases you want to use `./gradlew bootBuildImage` to generate application container images.

It doesn't require making a `Dockerfile` and results in a better (more maintainable and more secure) image.

To configure the image name you can add the following to the `build.gradle` file.

```gradle
bootBuildImage {
  imageName = "recrd/${project.name}"
}
```

## AWS access

We host our infrastructure on AWS. To access the AWS account (or accounts in the future) we're using IAM roles.

Each developer has their own IAM user with associated API keys. Keep them secret, do not share them, do not store them in clear text if possible.

## Assuming IAM roles

IAM users are configured with minimal credentials, which should be sufficient to [enable MFA][mfa] and create API keys.

To be able to do any meaningful work, you have to assume an appropriate role. For developers, currently two roles are available.

- `readonly`: As the name suggests you can read most AWS resources with it, this is the one you should use most of the time to access AWS Console.
- `developer`: Currently there's no special permissions for AWS Console, this is likely to change as time passes. Use this role to access Kubernetes.

[aws-vault][] is a tool simplifying IAM role assumptions. It also keeps your API keys encrypted.

[aws-vault]: https://github.com/99designs/aws-vault
[mfa]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html

### Install packages

```shell
brew install awscli kubectl@1.22
brew install --cask aws-vault aws-vpn-client
```

### Configuration

1. If you don't have a VPN account yet, follow [this guide][client vpn].
2. Add the following to your `~/.aws/config` file. (Change your email address on both lines.)
   ```properties
   [profile recrd]
   mfa_serial=arn:aws:iam::378942204220:mfa/<your_recrd_email_address>
   role_session_name=<your_recrd_email_address>
   region=eu-west-1

   [profile recrd/developer]
   include_profile=recrd
   source_profile=recrd
   role_arn=arn:aws:iam::378942204220:role/developer

   [profile recrd/readonly]
   include_profile=recrd
   source_profile=recrd
   role_arn=arn:aws:iam::378942204220:role/readonly
   ```
3. Add your credentials to `aws-vault`.
   ```shell
   aws-vault add recrd
   Enter Access Key ID: <your_access_key_id>
   Enter Secret Access Key: <your_secret_access_key>
   Added credentials to profile "recrd" in vault
   ```
4. Test your `recrd` profile
   ```shell
   aws-vault exec recrd -- aws sts get-caller-identity
   Enter token for arn:aws:iam::378942204220:mfa/<your_recrd_email_address>: 577783
   {
       "UserId": "<your_access_key_id>",
       "Account": "378942204220",
       "Arn": "arn:aws:iam::378942204220:user/<your_recrd_email_address>"
   }
   ```
5. Test login to AWS Console. This should open a new browser tab. Navigate to S3 where you should be able to see the buckets now.
   ```shell
   aws-vault login recrd/readonly
   ```

[client vpn]: ./bootstrap/client_vpn.md#how-to-get-vpn-access

### Access Kubernetes cluster

1. Connect to the VPN.
2. Configure [this file][kubeconfig.yaml] as your Kubernetes config file. (Change the path to point to the config file on your machine.)
   ```shell
   export KUBECONFIG=~/git/recrd/terraform/kubernetes/kubeconfig.yaml
   ```
3. List pods
   ```shell
   aws-vault exec recrd/developer -- kubectl get pods
   ```
4. Try out Kubernetes commands from the top of this page

[kubeconfig.yaml]: ./kubernetes/kubeconfig.yaml
