# poc-terraform-change-instance-type-hibernation

## Description

- Change EC2 instans type which is:
  - Managed by terraform
  - Hibernation enabled

## Procedure

- Setup env
  - `make start`
- Change instance type and refresh terraform state
  - `bash ./scripts/change-instance-type.sh`
- Ensure nodiff
  - `terraform plan -var-file="2nd.tfvars"`
