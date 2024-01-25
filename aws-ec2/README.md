# Seqera Platform installer for AWS EC2

## Requirements

* Terraform 1.6.2 or later
* AWS CLI
* AWS IAM User with "Admin"
* [k3sup](https://github.com/alexellis/k3sup)

## Before you start

* Create a AWS IAM user that will used to create the AWS environment and access to it. The user should have
  `AdministratorAccess` IAM policy.
* Choose an AWS region where the EC2 virtual machine running Seqera Platform will be deployed.
* Make sure the AWS Simple Email Service (SES) in the selected region has *production access*.
* Choose an email address that will use to send email by Seqera Platform and add it in the *Verified identities*
  of the SES services. See [AWS SES documentation for details](https://docs.aws.amazon.com/ses/latest/dg/creating-identities.html#verify-email-addresses-procedure).
* Install Terraform if you don't have it already. See [Terraform documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) for details.
* Install AWS command line tool if you don't have it already. See [AWS documentation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) for details.


## Getting started

### 1. AWS config profile

Create an AWS configuration profile that it will be used to setup and deploy the EC2 instance where Seqera Platform
will be installed.

```
aws --profile <PROFILE NAME> configure
```

Replace `<PROFILE NAME>` with a profile name of your choice e.g. `seqera-config`. When asked specify the AWS credentials
of the AWS IAM account that will be used to deploy the cluster. The user should have the `AdministratorAccess` IAM policy.

> [!Important]
> The use of AWS credentials defined via environment variable is not supported. Make sure to unset the following
> variable if they are defined in your environment: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_ACCESS_KEY`,
> `AWS_SECRET_KEY`.

Make sure to unset all AWS environment variables with this command:

```
unset "${!AWS@}"
```

### 2. Environment configuration

Create a copy of the `templates/settings.template.sh` file, giving it the name `settings.sh` and specify the value of the
following parameters:

| Parameter | Description
| --- | --- |
| `AWS_REGION`      | The AWS region where the cluster will be deployed e.g. `eu-west-1`    |
| `AWS_PROFILE`     | The AWS configuration profile used to setup and deploy the cluster e.g. `seqera-config` |
| `TOWER_APP_HOSTNAME`   | The domain to be used to access the Seqera Platform service e.g. `platform.company.com` |
| `TOWER_CONTACT_EMAIL` | The email address that will be used as sender when delivering email notification by Seqera Platform e.g. `support@company.com` |
| `TOWER_DB_PASSWORD`   | The password for Seqera Platform relational database.
| `TOWER_DB_ADMIN_PASSWORD`       | The admin password for Seqera Platform relational database.
| `TOWER_JWT_SECRET`              | Secret used to generate the login JWT token. Use a long random string (35 chars or more).
| `TOWER_CRYPTO_SECRETKEY`        | Key used to encrypt secrets. Use a long random string (25 chars or more). |
| `TOWER_LICENSE`                 | Your Tower license key. If you don't have a license key contact `sales@seqera.io`. |
| `TOWER_HTTPS_CERTIFICATE_ARN`   | The ARN of the certificate created visa AWS Certificate manager matching the domain specified by the parameter `TOWER_SERVER_NAME`. Only for public facing, it can be ignored otherwise. |
| `SEQERA_CR_PASSWORD`            | The username to access the Seqera container registry to providing the images for installing Seqera Platform |
| `SEQERA_CR_USER`                | The password to access the Seqera container registry to providing the images for installing Seqera Platform |

> [!Note]
> Review also the remaining parameters default values in the `settings.sh` and change them accordingly your requirements if needed.


### 3. Cluster deployment

Use the following file to create the Terraform main file configured with your settings

```bash
bash create-terraform-main.sh
```

Init the Terraform environment with the following command:

```bash
terraform init
```

Check the Terraform plan

```bash
terraform plan
```

Deploy the required AWS environment using the Terraform `apply` command:

```bash
terraform apply -auto-approve
```

This step will take a few minutes to deploy the Mysql RDS database, the Redis Elasticache instance and
the EC2 virtual machine.


When it complete, install the Kubernetes cluster in the EC2 instance using this command:

```bash
bash setup-kubernetes.sh
```

Verify you can connect to the cluster using this command:

```
export KUBECONFIG=$PWD/kubeconfig
kubectl get ns
```


Setup the target database using this command:

```bash
bash setup-database.sh
```

Deploy the Seqera Platform stack using this command:


```bash
bash deploy-app.sh
```

Verify the corresponding services and pods were deployed, using the command below:

```
kubectl get pods
```

An output similar to the following one should be shown:

```
NAME                        READY   STATUS    RESTARTS     AGE
frontend-845555f54b-cnpqn   1/1     Running   0            104s
backend-7b85bff7f9-2rpp6    1/1     Running   0            104s
cron-845866f5ff-zrf8l       1/1     Running   0            104s
```

Once all pod are in `Running` status you can connect to the Seqera Platform via the using this command:


```
kubectl port-forward deployment/frontend 8000:80
```

Then open your browser at the address http://localhost:8000, the Seqera Platform login page should be shown.

Try to login using an email address that was validated in the AWS SES console for cluster deployment region.

If you have not requested production access for the AWS SES service, the login email very likely will be delivered in
*spam* inbox.

> [!Note]
> The link in the sign-in email will only work if you have configured `localhost:8000` as the value for `TOWER_APP_HOSTNAME` in the `setting.sh` file.


### 5. Configure ingress controller

Run the following command to configure the Kubernetes ingress controller:

```
bash deploy-ingress.sh
```

The ingress can requires a few seconds to be ready, you can watch the status using this command:


```
kubectl get ingress -w
```

It will show an output like the following:

```
NAME            CLASS     HOSTS                                                  ADDRESS      PORTS   AGE
tower-ingress   traefik   ec2-18-185-60-113.eu-central-1.compute.amazonaws.com   10.0.16.97   80      6s
```

Open in the browser the hostname reported in the column `HOSTS`.


## Uninstallation

To uninstall Seqera Platform deployment, use the following command:

To uninstall the Seqera platform, the EC2 instance, RDS database and Elasticache instance, use the following command:

```
terraform destroy
```

> [!Warning]
> This operation cannot be undone. Make sure to backup the RDS database instance if you want to preserve the data.

