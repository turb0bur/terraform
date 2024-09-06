# EPAM DevOps Mentoring Course

## Description
This project includes next AWS services:
1. VPC
- Subnets (public and private)
- Route Tables
- Internet Gateway
- NAT Instance
- Security Groups
- VPC Endpoints
2. EC2
- Instances
- Autoscaling Group
- Application Load Balancer
3. S3
4. SSM

## Setup
1. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. Initialize the project
```bash
terraform init
```
3. Create and choose a [workspace](#multiple-environments) for the environment
4. Create a plan providing the region file
```bash
terraform plan -var-file=regions/eu-central-1.tfvars
```
5. Apply the plan
```bash
terraform apply -var-file=regions/eu-central-1.tfvars
```

## Multiple environments

The project supports multiple environments (dev, stage, prod) and can be deployed using workspaces.

To add a new environment, create a new workspace and set the environment variables.

```bash
terraform workspace new dev
```
To switch between environments, use the following command:

```bash
terraform workspace select dev
```
To list all available workspaces, use the following command:

```bash
terraform workspace list
```
There are two environments by default: **dev** and **prod** with corresponding set of variables.
After adding a new environment, you need to create a new .tfvars file e.g. `stage.tfvars` and add the values for the new environment.

## Multiple regions
You can deploy the project in multiple regions by providing the region file.
Also, you can add new variables for the existing resources in the region file.

## Destroy
To destroy the infrastructure, run the following command with the region file:
```bash
terraform destroy -var-file=regions/eu-central-1.tfvars
```