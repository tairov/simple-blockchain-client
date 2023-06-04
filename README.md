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

The main design decision in this Terraform project was to split the infrastructure into modules and use Terraform
workspaces to manage different environments. This allows for easier management of resources and separation of
environments during development.
Using modules in this way makes it easier to add, update, and remove services, because an engineer can do so by
maintaining only a couple of files in a single place - main.tf and <ENV>.tfvars rather than having to search through the
huge single main.tf. It also makes the code more organized, easier to understand, simpler to refactor, since we
eliminated code/logic duplication.

Using modules in this way makes it easier to add, update, and remove services, because an engineer can do so by
maintaining only a couple of files in a single place - `main.tf` and `<ENV>.tfvars` rather than having to search through
the huge single `main.tf`. It also makes the code more organized, easier to understand, simpler to refactor, since we
eliminated code/logic duplication.

### Using Terraform Workspaces for Development and CI/CD

Terraform workspaces allow for the creation of separate environments within a single configuration. This is useful for
development as it allows for easy testing of changes without affecting other environments. It also allows for the
creation of specific environments for different stages of the CI/CD pipeline, such as development, staging, and
production.

Essentially we have 2 types of CI/CD pipelines.

1. CI/CD for the infra code (Terraform, ansible, etc.)
2. CI/CD for the apps & services

In both cases the refactored modules repository could be nicely integrated into the pipelines.

#### CI/CD for the client service

See: `.github/workflows/build.yml`

Build pipeline is implemented in the github actions script. It contains the following steps:

* notify
* build-and-push-image

#### CI/CD for the Terraform infra

See: `.github/workflows/infra-update.yml`

I've implemented ready to use github actions script. Beside basic liniting & setup steps it also contains the following
which must convey the idea I'm proposing:

`Comment terraform plan` - that is executed when **Pull Reqeust** created with changes under `tf/*` path.
It creates a comment within Pull Request that will show the implied changes implemented in the commits.
This will only work if TF state is stored somehwere remotely like in AWS-S3 or in Terraform Cloud.

`Terraform Apply` - if PR merged then this step will apply all changes on infra

If the changes are successful in the staging environment, they can then be promoted to the production environment by
merging the staging branch into the production branch and running Terraform in the production workspace.


### Suggestions for Further Advancements

There are several ways that this solution could be further advanced:

1. Move the state to external storage like Terraform Cloud or AWS-S3. It must improve the security, auditing, collaboration and we can have versioning of infra changes.
2. As an out-of-the-box step - it might be much better to deploy services to kubernetes/minikube in order to get some advancements suggested in this list
3. Add set of features/services/solutions for Observability
4. Implement basic features for horizontal/vertical scaling/autoscaling of services
5. Implementing testing of the deployed infrastructure, such as integration tests or acceptance tests, to ensure that the infrastructure is functioning as expected. I'd suggest to use `Cucumber` scripts for covering all necessary cases. For `production` I'd suggest to implement Game-day by injecting different level failures on the infra ( chaos engineering )
6. Automating the promotion of changes from staging to production (or at least from dev to staging), such as through the use of approval processes or manual intervention. Which is partially implemented in the POC script I've provided (see: `.github/workflows/infra-update.yml`)
7. Implementing a rollback mechanism to allow for easy reversal of changes in the event of failures or issues.
8. Adding additional security measures, such as the use of secrets management or encryption of sensitive data.

