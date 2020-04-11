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
Infrastructure-builder is a set of resources and configurations that you have to set up on your project in order to automate resource provisioning, the main component of Infrastructure builder is __infra-builder__ which is a custom builder on [conttainer registery](https://cloud.google.com/container-registry) that you have to make it available in your project as part of Infrastructure-Builder setup and make sure to distinguish between the two terms (Infrastructure-Builder and Infra-builder) to understand the rest.

[Cloud Build](https://cloud.google.com/cloud-build) makes use of [Cloud builders](https://cloud.google.com/cloud-build/docs/cloud-builders) in order to perform the steps you define in the Cloudbuild.yaml file check the link below to know more about writing Cloudbuild.yaml, some of the native builders are gcloud, docker, mvn, etc. The complete list of supported builders for Cloud Build is [here](https://github.com/GoogleCloudPlatform/cloud-builders).

A Cloud builder is a container image with commun language and tools installed in them. Infra-builder is a custom builder that runs Terraform, go and python. [check infra-builder source code](link) for more details.

<img src="images/infrastructure-builder.png" width="70%"/>
