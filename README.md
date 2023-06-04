# block chain client service example

### Endpoints:

`/block/<id>` - returns JSON response with block number retrieved from block chain API
`/get_block_by_number/<number>` - returns JSON response with block information

`/metrics` - returns metrics in plain text format supported by Prometheus
`/health` - returns JSON status of the service

### Terraform setup

Bucket for TF state must be created before `terraform init`

### Tests

Run tests via script :
`./scripts/run_tests.sh`