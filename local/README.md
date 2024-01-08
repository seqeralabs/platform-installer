# Seqera Platform installer in local computer

This guide shows how to setup Seqera Platform in a local computer.

> [!Note]
> This installation is meant only for testing or evaluation purposes.

## Requirements

* Linux or macOS computer
* Docker runtime
* [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) command line tool

## Getting started

### 1. Environment configuration

Create a copy of the `templates/settings.template.sh` file, giving it the name `settings.sh` and specify the value of the
following parameters:

| Parameter | Description
| --- | --- |
| `TOWER_CONTACT_EMAIL`           | The email address that will be used as sender when delivering email notification by Seqera Platform e.g. `support@company.com` |
| `TOWER_DB_ADMIN_PASSWORD`       | The admin password for Seqera Platform relational database.
| `TOWER_DB_PASSWORD`             | The password for Seqera Platform relational database.
| `TOWER_JWT_SECRET`              | Secret used to generate the login JWT token. Use a long random string (35 chars or more).
| `TOWER_CRYPTO_SECRETKEY`        | Key used to encrypt secrets. Use a long random string (25 chars or more). |
| `TOWER_LICENSE`                 | Your Tower license key. If you don't have a license key contact `sales@seqera.io`. |
| `SEQERA_CR_PASSWORD`            | The username to access the Seqera container registry to providing the images for installing Seqera Platform |
| `SEQERA_CR_USER`                | The password to access the Seqera container registry to providing the images for installing Seqera Platform |

> [!Note]
> Review also the remaining parameters default values in the `settings.sh` and change them accordingly your requirements if needed.

### 2. Cluster configuration

For the sake of this installation a single-node Kubernetes cluster is going to be setup in
a Docker container by using [k3d](https://k3d.io/).

If you are using a macOs computer install k3d using this command:

```bash
$ brew install k3d
```

If you are using a Linux computer install k3d using this command:

```bash
$ curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
```

Once k3d is installed, setup a Kubernetes cluster using this command:

```bash
bash setup-kubernetes.sh
```

Verify the Kubernetes cluster is up and running using this command:

```bash
kubectl get ns
```

The following namespaces should be showed:

```bash
NAME              STATUS   AGE
default           Active   2m42s
kube-system       Active   2m42s
kube-public       Active   2m42s
kube-node-lease   Active   2m42s
seqera-platform   Active   2m32s
```

Deploy the MySLQ database, the Redis cache and the SMTP service using this command:

```bash
bash setup-infra.sh
```

When complete the following pods should be reported:

```bash
» kubectl get pods
NAME                   READY   STATUS    RESTARTS   AGE
redis-0                1/1     Running   0          56s
mysql-0                1/1     Running   0          56s
smtp-fbd99cf4c-ptlts   1/1     Running   0          56s
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
NAME                        READY   STATUS              RESTARTS   AGE
redis-0                     1/1     Running             0          4m20s
mysql-0                     1/1     Running             0          4m20s
smtp-fbd99cf4c-ptlts        1/1     Running             0          4m20s
backend-7b85bff7f9-s4clv    0/1     ContainerCreating   0          18s
cron-6465789996-k4jr9       0/1     Init:0/1            0          18s
frontend-845555f54b-4l2tl   1/1     Running             0          18s
```

Once all pod are in `Running` status you can connect to the Seqera Platform via the using this command:

```
kubectl port-forward deployment/frontend 8000:80
```

Then open your browser at the address http://localhost:8000, the Seqera Platform login page should be shown.

Try to login using using your email address. The email will NOT be delivered to the real recipient but to a sandbox mail
account. To access it run the command below, then open your browser at this link http://localhost:1080

```
kubectl port-forward deployment/smtp 1080:1080
```

> [!Note]
> The link in the sign-in email will only work if you have configured `localhost:8000` as the value for `TOWER_HOSTNAME` in the `setting.sh` file.


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
NAME            CLASS     HOSTS       ADDRESS      PORTS   AGE
tower-ingress   traefik   localhost   172.22.0.3   80      5s
```

Then open your browser at the address http://localhost:8000, the Seqera Platform login page should be shown.


## Uninstallation

To uninstall Seqera Platform deployment, use the following command:

```
bash uninstall-app.sh
```

To uninstall the local Kubernetes cluster use this command:

```
uninstall-kubernetes.sh
```

