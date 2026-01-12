# taccoform-localstack
Testing localstack+terraform+rds


### Pre-flight

1. Sign up for localstack
2. :scream: when you see $80/mo price
3. Install `docker`
4. Install `localstack`
5. Configure localstack
6. Install `terraform`
7. Install `uv`
8. Run `uv sync`
9. Start localstack: `localstack start`

### Notes

* There are no RDS examples in the terraform examples repo
* LocalStack Community and Pro images provide limited offline capabilities. To use a fully-fledged offline mode, you may use LocalStack Enterprise
* Localstack "base" has RDS access, but not AWS DMS access (need ultimate)
* If you're using modules that include provider blocks, you will need to add extra configuration for `tflocal` to work

### Useful commands

* Describe RDS cluster: `uv run awslocal rds describe-db-clusters`
* Run terraform wrapper: `uv run tflocal apply`

### Resources

* [LocalStack - Terraform Examples](https://github.com/localstack-samples/localstack-terraform-samples)

* [LocalStack - RDS](https://docs.localstack.cloud/aws/services/rds/)
