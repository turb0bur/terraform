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
3. Create and choose a [workspace](#multiple-workspaces) for the environment
4. Create a .tfvars file for the workspace e.g. `workspaces/euc1-test.tfvars` and add needed values.
5. Create corresponding plan providing the workspace file  
```bash
terraform plan --var-file=workspaces/euc1-dev.tfvars
```
6. Apply the plan
```bash
terraform apply --var-file=workspaces/euc1-dev.tfvars
```

## Multiple workspaces

The project supports multiple workspaces. Workspace is a combination of AWS region and environment e.g. `euc1-dev` or `use1-prod`.
To create a new workspace, use the following command:
```bash
terraform workspace new euc1-test
```
To switch between environments, use the following command:

```bash
terraform workspace select euc1-test
```
To list all available workspaces, use the following command:

```bash
terraform workspace list
```
There are 4 predefined workspaces (2 regions * 2 envs) by default: **euc1-dev**, **euc1-prod**, **eun1-dev**, **eun1-prod** with corresponding set of variables.

## Destroy
To destroy the infrastructure, run the following command with the region file:
```bash
terraform destroy --var-file=workspaces/euc1-dev.tfvars
```