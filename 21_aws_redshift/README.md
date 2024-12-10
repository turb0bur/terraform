# UCU DevOps Course. DBT Homework Infrastructure

## Description
This project includes next AWS services:
1. VPC
- Subnets (public for Bastion Host and private for Redshift)
- Route Tables
- Internet Gateway
2. EC2
- Bastion Host (For secure access to Redshift via SSM)
- Security Groups (For Redshift and Bastion EC2)
3. Redshift (Single Node Cluster)
4. SSM (Parameter Store for Redshift db credentials)
5. IAM (2 roles for Redshift and Bastion EC2 with corresponding policies)

## Setup
1. Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. Initialize the project using the following command:
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

## Destroy
To destroy the infrastructure, run the following command with the region file:
```bash
terraform destroy --var-file=workspaces/euc1-dev.tfvars
```