# bootstrap

Terraform base resources which are not supposed to be changing frequently.

The outputs are used by other Terraform workspaces, you have to remove dependencies before you can remove resources here.

## Known issues

- Client VPN Endpoint creation is slow, subnet associations might time out

---
## Client VPN
AWS Client VPN is the recommended and supported method to access private Recrd AWS resources. This applies to everyone, including employees, contractors and third parties.

The VPN is configured in a way, that only the traffic destined to AWS will go through it (split tunnel).

The self service prortal is not configured.

### User provisioning (for admins)

The current solution utilizes AWS SSO as the authentication backend. Users are provisioned via [AWS SSO Admin](https://eu-west-1.console.aws.amazon.com/singlesignon/identity/home?region=eu-west-1#!/dashboard).

MFA device registration is enforced when user sets up their account and MFA is enforced for each login. See confugration in the Console under AWS SSO/Settings.


1. Create a user manually. The username should be the user's `email` address as per convention.
2. Assign user to the appropriate group. Client VPN will not work unless the user is assigned to a group.
   - Recrd Admins
   - Recrd Developers
   - Third Parties
3. An email will be automatically sent out to the user with instructions to set up account with MFA.

### How to get VPN access (for users)
1. Request in `#infra` slack channel for a new user to be provisioned with the following details:

   ```
   New user request for Client VPN
   -------------------------------
   email:
   first name:
   last name:
   when this is needed by:
   ```

2. Once created, the user will receive an email with instructions for setting up an AWS account
3. Please set up a new password and [configure MFA](https://docs.aws.amazon.com/singlesignon/latest/userguide/user-device-registration.html)
4. Download and install [VPN Client](https://aws.amazon.com/vpn/client-vpn-download/)
5. Download the profile configuration file. Create a new profile called `Recrd Client VPN` using the file.

    `#FIXME where to store?`
6. Initiate a connection to VPN. Log in via [Recrd AWS User Portal](https://d-9367775953.awsapps.com/start) in the browser window, which will open automatically.
7. Private resources should now be accessible.

Docs:
- [AWS Client VPN User guide](https://docs.aws.amazon.com/vpn/latest/clientvpn-user/user-getting-started.html)
- [AWS User Portal](https://docs.aws.amazon.com/singlesignon/latest/userguide/using-the-portal.html)

## How to get help?
1. Please check if you followed the instructions as documented
2. If your problem is still unresolved, reach out to us via `#infra` slack channel.

### TODO
- integrate authentication with GSuite

   Past investigations:
   - Currently not supported out of the box. See [details here](https://aws.amazon.com/blogs/security/how-to-use-g-suite-as-external-identity-provider-aws-sso/)
      ```
      May 4, 2021: AWS Single Sign-On (SSO) currently does not support G Suite as an identity provider for automatic provisioning of users and groups, or the open source ssosync project, available on Github.
      ```
    - Using GSuite SAML app doesn't accept http ASC urls, which is a requirement for AWS. Only [dirty hack](https://benincosa.com/?p=3787) is available as a workaround. 
