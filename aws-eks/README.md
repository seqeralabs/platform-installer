# Seqera Platform installer for AWS EKS

This Terraform script streamlines the deployment of Seqera Platform and required infrastructure.

It deploys:

* AWS RDS (MySQL)
* AWS Elasticache (Redis)
* AWS EKS cluster 
* AWS Application load-balancer (optional)


## Requirements

* Terraform 1.5.x 
* AWS CLI 
* AWS IAM User with "Admin"


## Before you start

* Create a AWS IAM user that will used to deployed the EKS cluster and access to it. The user should have
  `AdministratorAccess` IAM policy.
* Choose an AWS region where the EKS running Seqera Platform will be deployed.
* Make sure the AWS Simple Email Service (SES) in the selected region has *production access*.
* Choose an email address that will use to send email by Seqera Platform and add it in the *Verified identities*
  of the SES services. See [AWS SES documentation for details](https://docs.aws.amazon.com/ses/latest/dg/creating-identities.html#verify-email-addresses-procedure).
* Install Terraform if you don't have it already. See [Terraform documentation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) for details.
* Install AWS command line tool if you don't have it already. See [AWS documentation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) for details.

## Getting started

### 1. AWS config profile

Create an AWS configuration profile that it will be used to setup and deploy the EKS cluster.

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

Create a copy of the `settings.template.sh` file, giving it the name `settings.sh` and specify the value of the
following parameters:

| Parameter | Description
| --- | --- |
| `AWS_REGION`      | The AWS region where the cluster will be deployed e.g. `eu-west-1`    |
| `AWS_PROFILE`     | The AWS configuration profile used to setup and deploy the cluster e.g. `seqera-config` |
| `AWS_USER_ARN`    | The ARN of the AWS user that will operate the EKS cluster |
| `TOWER_DOMAIN_NAME`   | The domain to be used to access the Seqera Platform service e.g. `platform.company.com` |
| `TOWER_CONTACT_EMAIL` | The email address that will be used as sender when delivering email notification by Seqera Platform e.g. `support@company.com` |
| `TOWER_JWT_SECRET`    | Secret used to generate the login JWT token. Use a long random string (35 chars or more).
| `TOWER_CRYPTO_SECRETKEY`        | Key used to encrypt secrets. Use a long random string (25 chars or more). |
| `TOWER_LICENSE`                 | Your Tower license key. If you don't have a license key contact `sales@seqera.io`. |
| `TOWER_HTTPS_CERTIFICATE_ARN`   | The ARN of the certificate created visa AWS Certificate manager matching the domain specified by the parameter `TOWER_SERVER_NAME`. Only for public facing, it can be ignored otherwise. |
| `SEQERA_CR_PASSWORD`            | The username to access the Seqera container registry to providing the images for installing Seqera Platform |
| `SEQERA_CR_USER`                | The password to access the Seqera container registry to providing the images for installing Seqera Platform |


> [!Note]
> Review also the remaining parameters default values in the `settings.sh` and change them accordingly your requirements if needed.

### 3. Cluster deployment

Use the following file to create the Terraform main file configured with your settings

```
bash create-terraform-main.sh
```

Create the S3 bucket that where Terraform state will be persisted:

```
bash create-terraform-bucket.sh
```

Init the Terraform environment with the following command:

```
terraform init
```

Check the Terraform plan

```
terraform plan
```

Deploy the EKS cluster using the Terraform `apply` command: 

```
terraform apply -auto-approve
```

Once the deployment process is complete, update your Kubernetes configuration so that
you can connect to the newly created cluster using  this command:

```
bash setup-kube-config.sh
```

Verify the cluster can be reached using this command:

```
kubectl get ns
```

It should print something like this:

```
NAME              STATUS   AGE
default           Active   1h
kube-node-lease   Active   1h
kube-public       Active   1h
kube-system       Active   1h
seqera-platform   Active   1h
```


### 4. Seqera Platform deployment

Deploy the Seqera Platform using this command:

```
bash deploy-app.sh
```

Verify the corresponding services and pods were deployed, using the command below:

```
kubectl get pods
```

An output similar to the following one should be shown:

```
NAME                        READY   STATUS      RESTARTS     AGE
backend-dd9d8495d-w594d     0/1     Running     0            21s
cron-777485bcf8-2m5cf       0/1     Init:0/1    1 (8s ago)   21s
frontend-845555f54b-ljmzr   1/1     Running     0            20s
seqera-db-setup-job-xyz   0/1     Completed   0            11h
```

> [!Note]
> The pod `seqera-db-setup-job-xyz` is created during the setup and can be safely deleted.

Once all pod are in `Running` status you can connect to the Seqerea Platform via the using this command:


```
kubectl port-forward deployment/frontend 8080:80
```

Then open your browser at the address http://localhost:8080, the Seqera Platform login page should be shown.

Try to login using an email address that was validated in the AWS SES console for cluster deployment region.

If you have not requested production access for the AWS SES service, the login email very likely will be delivered in
*spam* inbox.

> [!Note]
> The link in the sign-in email will only work if you have configured `localhost:8080` as the value for `TOWER_DOMAIN_NAME` in the `setting.sh` file.


### 5. Configure TLS termination and public facing

This step configure a Kubernetes ingress controller and an AWS Application Load balancer to make your Seqera Platform
installation accessible through the public internet. You may need to change this configuration according your
network requirements.

Run the following command to configure the Kubernetes ingress controller:


```
bash deploy-ingress.sh
```

The ingress can requires a few seconds to be ready, you can watch the status using this command:


```
kubectl get ingress -w
```

Once ready retrieve the AWS Load balancer hostname with this command:

```
export AWS_ALB_HOSTNAME=$(k get ingress tower-ingress  -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo $AWS_ALB_HOSTNAME
```


Create an *alias record* in your Route53 configuration to associate the Seqera Platform domain specified via the
variable `TOWER_DOMAIN_NAME` with the AWS Application load balancer hostname specified by `AWS_ALB_HOSTNAME`.

See [AWS documentation](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-to-elb-load-balancer.html) for further details.


## Uninstallation

To uninstall Seqera Platform deployment, use the following command:

```
bash uninstall-app.sh
```

To uninstall the EKS cluster, RDS database and Elasticache instance, use the following command:

```
terraform destroy
```

> [!Warning]
> This operation cannot be undone. Make sure to backup the RDS database instance if you want to preserve the data.

Finally delete the S3 bucket used by Terraform using the command below:

```
bash uninstall-terraform-bucket.sh
```
