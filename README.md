# xTerraform

xTerraform package will provide project with easily scalable and maintainable cloud infrastructure.

## Contents

- [Requirements](#requirements)

- [Installation](#installation)

## Requirements

1. Install Terraform CLI in your machine: [https://www.terraform.io/downloads.html].

2. Optionally: 
    - For AWS infrastructure:
        1. Install AWS CLI in your machine: [https://aws.amazon.com/cli/].
        2. Verify or update AWS CLI credential: [https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html].

## Installation

Installation of xTerraform is per project basis. So do the following:

1. Open terminal, change directory to current project root folder.

2. Install xTerraform: `composer require heyday/xterraform`.

3. Publish Terraform templates to desired directory: `cp vendor/heyday/xterraform/terraform .xterraform/test`.

4. Navigate to that directory: `cd .xterraform/test`.

5. Update `values.tfvars` as needed.

6. Initialize Terraform: `terraform init`.

## Application

1. Apply infrastructure: `terraform apply -var-file=values.tfvars`

## Destruction

1. Apply infrastructure: `terraform destroy -var-file=values.tfvars`