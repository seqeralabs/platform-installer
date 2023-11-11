## Seqera Platform launcher for AWS EKS 

This Terraform script streamlines the deployment of Seqera Plaform and required infrastructure. 

It deploys:

* AWS RDS (MySQL)
* AWS Elasticache (Redis)
* AWS EKS cluster 
* AWS Application load-balancer (optional)


### Requirements 

* Terraform 1.5.x 
* AWS CLI 
* AWS IAM User with "Admin


### Before you start

* Create a AWS IAM user that will used to deployed the EKS cluster and access to it. The user should have
  `AdministratorAccess` IAM policy.
* Choose an AWS region when the EKS running Seqera platform will be deployed.
* Make sure the AWS Simple Email Service (SES) in the selected region has *production access*.
* Choose an email address that will use to send email by Seqera Plaform and add it in the *Verified identities*
  of the SES services. See [AWS SES documentation for details](https://docs.aws.amazon.com/ses/latest/dg/creating-identities.html#verify-email-addresses-procedure).
* Install Terraform if you don't have it already. See [Terraform documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) for details.
* Install AWS command line tool if you don't have it already. See [AWS documentation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) for details.

### Getting started

#### 1. AWS config profile

Create an AWS configuration profile that it will be used to setup and deploy the EKS cluster.

```
aws --profile <PROFILE NAME> configure
```

Replace `<PROFILE NAME>` with a profile name of your choice e.g. `seqera-config`. When asked specify the AWS credentials
of the AWS IAM account that will be used to deploy the cluster. The user should have the `AdministratorAccess` IAM policy.

#### 2. Environment configuration

Create a copy of the `settings.template.sh` file, giving it the name `settings.sh` and specify the value of the
following parameters:

| Parameter | Description
| --- | --- |
| `AWS_REGION`      | The AWS region where the cluster will be deployed e.g. `eu-west-1`    |
| `AWS_PROFILE`     | The AWS configuration profile used to setup and deploy the cluster e.g. `seqera-config` |
| `AWS_USER_ARN`    | The ARN of the AWS user that will operate the EKS cluster |
| `TOWER_DOMAIN_NAME`   | The domain to be used to access the Seqera platform service e.g. `platform.company.com` |
| `TOWER_CONTACT_EMAIL` | The email address that will be used as sender when delivering email notification by Seqera platform e.g. `support@company.com` |
| `TOWER_JWT_SECRET`    | Secret used to generate the login JWT token. Use a long random string (35 chars or more).
| `TOWER_CRYPTO_SECRETKEY`        | Key used to encrypt secrets. Use a long random string (25 chars or more). |
| `TOWER_LICENSE`                 | Your Tower license key. If you don't have a license key contact `sales@seqera.io`. |
| `TOWER_HTTPS_CERTIFICATE_ARN`   | The ARN of the certificate created visa AWS Certificate manager matching the domain specified by the parameter `TOWER_SERVER_NAME`. Only for public facing, it can be ignored otherwise. |
| `SEQERA_CR_PASSWORD`            | The username to access the Seqera container registry to providing the images for installing Seqera platform |
| `SEQERA_CR_USER`                | The password to access the Seqera container registry to providing the images for installing Seqera platform |


Review also the remaining parameters default values in the `settings.sh` and change them accordingly your requirements if needed.

#### 3. Cluster deployment

Use the following file to create the Terraform main file configured with your settings

```








