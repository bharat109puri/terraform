# Client VPN

## Overview
AWS Client VPN is the recommended and supported method to access private Recrd AWS resources. This applies to everyone, employees, contractors and third parties. VPN access must only be granted if it's needed. VPN access must be revoked when no longer needed.

## Admin Guide

The current solution utilizes AWS SSO as the authentication backend.

As terraform support for AWS SSO is very limited at the time of the implementation, some manual steps had to be performed via the Console:
1. Enabled AWS SSO for the organization
2. Enforced MFA device registration during profile setup and that a token required for every login
3. Created AWS SSO SAML App and added metadata xml to this directory

   ```text
   name: AWS Client VPN (SAML App)
   id:   ins-09e3f2528b89c950
   ```

### User provisioning
Currently terraform support is limited, users are provisioned via [AWS SSO Admin](https://eu-west-1.console.aws.amazon.com/singlesignon/identity/home?region=eu-west-1#!/dashboard) in the Console.

1. Create a user. The username should be the user's `email` address as per convention
2. Assign user to the appropriate group. Client VPN will not work unless the user is assigned to a group
   - Recrd Admins
   - Recrd Developers
   - Third Parties
3. An email will be sent out to the user automatically with instructions to set up the account

## User Guide

### How to get VPN access
1. Request in `#infra` slack channel for a new user to be provisioned with the following details:

   ```text
   New user request for Client VPN
   -------------------------------
   email:
   first name:
   last name:
   when this is needed by:
   ```

2. Once created, the user will receive an email with instructions for setting up an AWS account
3. Follow the instructions to set up the password and [configure MFA](https://docs.aws.amazon.com/singlesignon/latest/userguide/user-device-registration.html)
4. Download and install the [AWS VPN Client](https://aws.amazon.com/vpn/client-vpn-download/)
5. Download the profile configuration file from [here](recrd-client-vpn-profile-config.ovpn)
6. Create a new profile called `Recrd Client VPN` using the file
7. Initiate a connection. Log in via [Recrd AWS User Portal](https://d-9367775953.awsapps.com/start) in the browser window, which will open automatically
7. Private resources should now be accessible

Docs:
- [AWS Client VPN User guide](https://docs.aws.amazon.com/vpn/latest/clientvpn-user/user-getting-started.html)
- [AWS User Portal](https://docs.aws.amazon.com/singlesignon/latest/userguide/using-the-portal.html)

### How to get help?

1. Please check if you followed the instructions as documented
2. If your problem is still unresolved, reach out to us via `#infra` slack channel

#### TODO
1. Integrate authentication with G Suite

   Past investigations:
   - Currently not supported out of the box. See [details here](https://aws.amazon.com/blogs/security/how-to-use-g-suite-as-external-identity-provider-aws-sso/)
      ```
      May 4, 2021: AWS Single Sign-On (SSO) currently does not support G Suite as an identity provider for automatic provisioning of users and groups, or the open source ssosync project, available on Github.
      ```
    - The G Suite SAML App on the Google side doesn't accept http ASC urls, which is a requirement for AWS. Only [dirty hack](https://benincosa.com/?p=3787) is available as a workaround.
