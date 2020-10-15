# aws-test

![Docker CI](https://github.com/PhilStainer/aws-test/workflows/Docker%20CI/badge.svg?branch=master&event=push)

aws-test is an example of AWS ECS with scaling, load balancing, logs and CI/CD via github actions.

## Installation

[Install terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)

```tfvars
# terraform.tfvars

aws_access_key = <aws_access_key>
aws_secret_key = <aws_secret_key>
ecs_cluster = <ecs_cluster_name>
```

## Usage

```tf
terraform init
terraform apply
```

This will build the AWS environment but you will need to trigger the github action to push the docker image.
