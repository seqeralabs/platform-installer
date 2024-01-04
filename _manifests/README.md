# Kubernetes deployment

This directory contains the Kubernetes deployment files structured using [Kustomize](https://kustomize.io/) tool.

Directories structure:

- `base`: Deployment configuration common to all environments;
- `env-aws-ec2`: Deployment configuration for AWS EKS based deployment;
- `env-aws-eks`: Deployment configuration for AWS EC2 based deployment;
- `env-local`: Deployment configuration local deployment;

### Useful links

* https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/

