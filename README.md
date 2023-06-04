# block chain client service example

### Endpoints:

`/block/<id>` - returns JSON response with block number retrieved from block chain API
`/get_block_by_number/<number>` - returns JSON response with block information

`/metrics` - returns metrics in plain text format supported by Prometheus
`/health` - returns JSON status of the service

### Terraform setup

`terraform init`

### Tests

Run tests via script :
`./scripts/run_tests.sh`


# Design decision

The main design decision in this Terraform project was to split the infrastructure into modules and use Terraform workspaces to manage different environments. This allows for easier management of resources and separation of environments during development.
Using modules in this way makes it easier to add, update, and remove services, because an engineer can do so by maintaining only a couple of files in a single place - main.tf and <ENV>.tfvars rather than having to search through the huge single main.tf. It also makes the code more organized, easier to understand, simpler to refactor, since we eliminated code/logic duplication.

Using modules in this way makes it easier to add, update, and remove services, because an engineer can do so by maintaining only a couple of files in a single place - `main.tf` and `<ENV>.tfvars` rather than having to search through the huge single `main.tf`. It also makes the code more organized, easier to understand, simpler to refactor, since we eliminated code/logic duplication.

### Using Terraform Workspaces for Development and CI/CD

Terraform workspaces allow for the creation of separate environments within a single configuration. This is useful for development as it allows for easy testing of changes without affecting other environments. It also allows for the creation of specific environments for different stages of the CI/CD pipeline, such as development, staging, and production.

Essentially we have 2 types of CI/CD pipelines.
1. CI/CD for the infra code (Terraform, ansible, etc.)
2. CI/CD for the apps & services

In both cases the refactored modules repository could be nicely integrated into the pipelines.  

**a.** ci/cd for the services

**Example:**
```
export TF_VAR_env_image_version='{"account":"feature/TASK-NNN"}'
terraform apply -var-file=$APP_ENV.tfvars
```
In this way we can inject the proper image version to the terraform.


#### CI/CD for the Terraform infra
See: `.github/infra-update.yml`

I've implemented ready to use github actions script. Beside basic liniting & setup steps it also contains the following which must convey the idea I'm proposing:

`Comment terraform plan` - that is executed when **Pull Reqeust** created with changes under `tf/*` path.
It creates a comment within Pull Request that will show the implied changes implemented in the commits.
This will only work if TF state is stored somehwere remotely like in AWS-S3 or in Terraform Cloud.


`Terraform Apply` - if PR merged then this step will apply all changes on infra

If the changes are successful in the staging environment, they can then be promoted to the production environment by merging the staging branch into the production branch and running Terraform in the production workspace.
