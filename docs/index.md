# Terraform Basics

Minimal examples and notes to learn Terraform and infrastructure-as-code.

## Overview
This repository contains small, focused Terraform examples and modules to demonstrate common patterns and workflows.

## Prerequisites
- Terraform (1.5+ recommended)
- Git
- (Dev container) Ubuntu 24.04.4 LTS

## Quick start
```bash
# from repository root
cd /workspaces/terraform-basics

# initialize providers & modules
terraform init

# format, validate, plan, and apply
terraform fmt
terraform validate
terraform plan -out=plan.tfplan
terraform apply "plan.tfplan"
```

To destroy:
```bash
terraform destroy
```

## Recommended workflow
- Keep each example/module in its own directory.
- Use workspaces or separate state backends per environment.
- Review `terraform plan` before `apply`.
- Store secrets outside of repo (e.g., environment variables, secret manager).

## Project layout (example)
- /examples — example configurations
- /modules — reusable Terraform modules
- /docs — documentation (see docs/index.md)
- main.tf, variables.tf, outputs.tf — root-level configs (if present)

## Documentation
See docs/index.md for authoring tips and site content.

## Contributing
Open an issue or PR. Follow standard Git workflow and run `terraform fmt` and `terraform validate` before submitting.

## License
Check repository LICENSE file for details.