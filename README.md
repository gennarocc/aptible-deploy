# Aptible Deployment Demo

## Github Action - Build and Deploy Frontend and Backend

The main build file can be found in `.github/workflows/build-deploy.yml`. The build is broken into three jobs.

1. `build-frontend`

Builds the frontend Docker image and pushes it to the AWS ECR.

2. `build-backend`
Builds the backend Docker image and pushes it to the AWS ECR.

4. `deploy`

Applys the existing terraform config to deploy the latest docker images to the application. This job requires the first two to finish before it can begin.

## Versioning

The workflow has a globaly defined major version for both frontend and backend. It uses the github action run number for the minor version.

## Terraform Provisioning

The terraform configuration is split into three segments

1. `terraform.fs`

Defines all providers and variables needed to provision a deployment. Uses an S3 state "backend" to manage the terraform state remotely and a dynamodb_table to manage the state lock.

2. `aptible.tf`

Defines the Aptible environment, apps, and service configurations. I kept the configuration minimal since I'm not working with an actual aplication, but this file could be expanded on for futher configuration. I.e. LoadBalancing, Security, Redis Cahce, ect...

3. `s3.tf`

Defines a private S3 bucket (private by default) called `gennaro-documents` ("stride-documents" was taken). With the requested read/write permisions and a configurable IAM.

## Secrets

All secrets are managed via Github's repository secrets and are accessed via `${{secrets.SECRET_NAME}}` in the Github Action.
