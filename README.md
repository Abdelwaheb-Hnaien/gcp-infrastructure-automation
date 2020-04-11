# Infrastructure automation on Google Cloud Platform

## What you need to know before guetting started ?
1. Google Cloud Platform
2. Terraform & IaC
3. Pipelines on Cloud Build

## How this works ?
Very simple !

1. Set up **Infrastructure-Builder** on your project
1. Write you **IaC**
2. Push the code to a Google Cloud repository
3. **Infrastructure-Builder** will provision you resources

## What is Infrastructure-Builder ?
Infrastructure-builder is a set of resources and configurations that you have to set up on your project in order to automate infrastructure provisioning.
[Cloud Build](https://cloud.google.com/cloud-build) makes use of [Cloud builders](https://cloud.google.com/cloud-build/docs/cloud-builders) in order to perform the steps you define in the Cloudbuild.yaml file. some of the native builders 
are gcloud, docker, mvn, etc. The complete list of supported builders for Cloud Build is [here](https://github.com/GoogleCloudPlatform/cloud-builders)
<img src="images/infrastructure-builder.png" width="70%"/>
