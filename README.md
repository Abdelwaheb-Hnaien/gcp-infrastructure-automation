# Infrastructure automation on Google Cloud Platform

## What you need to know before guetting started ?
1. Google Cloud Platform
2. Terraform & IaC
3. Pipelines on Cloud Build

## Brief introduction

A Cloud builder is a container image with commun language and tools installed in them. 

[Cloud Build](https://cloud.google.com/cloud-build) makes use of [Cloud builders](https://cloud.google.com/cloud-build/docs/cloud-builders) to perform the steps you define in the Cloudbuild.yaml file, check the link below to know more about writing Cloudbuild.yaml files. 

Some of the native builders are gcloud, docker, mvn, etc. The complete list of supported builders for Cloud Build is [here](https://github.com/GoogleCloudPlatform/cloud-builders).

## What is Infrastructure-Builder ?

Infrastructure-builder is a custom builder that runs Terraform, go and python.

## How this works ?

### Overview : 

<img src="images/infrastructure-builder.png" width="70%"/>

### Details :
Pushing the code (IaC) to container registery should trigger cloud build which will use Infrastructure builder to execute each step of the following pipeline in order to create resources : 

<img src="images/pipeline.png" width="70%"/>

#### Templating :
A practice when writing IaC is to separate configuration from logic, i.e to group together the infrastructure variables in a **config.yaml** file (a file/environment).

<img src="images/env.png" width="30%"/>

Infrastructure-builder supports __jinja templating__, that's  why the first step of the automation pipeline will feed those variables into the main code, next is an example of writing a Storage bucket and a Compute Instance with templating:
<img src="images/templating.png"/>
Templating step will generate the following IaC: <br/><br/> <img src="images/iac.png" width="70%"/>

#### Provisioning : 
Provisioning will simply run different Terraform commands (plan, apply) to deploy infrastructure.

The two steps are embedded together in the following declaration of **Cloudbuild.yaml** :
<img src="images/cloudbuild.png" width="70%"/>

This step supports only one argument that could be:<br/>
- __dry-deploy__: Infrastructure_builder will preform templating then terraform **plan**<br/>
- __deploy__: Infrastructure_builder will preform templating then terraform **apply**<br/>
- __clean__: Infrastructure_builder will preform templating then terraform **destroy**<br/>

## How to set up infrastructur builder in my GCP project ?
Infrastructure builder should be available in conatiner registery. Check this repository.

## Demo :

0. Make sure that infrastructure-builder is available in your project 

1. Clone this repository which an example of a project with many folders.

DevOps folder should be in the repository root folder and is mandatory, it should also keep the following structure:

<img src="images/devops.png" width="30%"/>

**modules** folder (optional): contains resource modules (in case you are writing modular IaC).

Folders in config/ represents your environments (dev, staging, prod, etc), each folder has a config.yaml file.

If you are devoloping the same Infrastructure for different environments than your config file should be in **config/\<your environment name>**

You tell infrastructure builder about which config file to use by setting he ENV variable in **Cloudbuild.yaml**.

2. Create a repository on Google Cloud Repositories

3. Set up a trigger in cloud build selecting ”Cloud Source Repository” as a repository hosting option

4. Select the repository you created in step 2

5. In the trigger settings make sure to set the build configuration to ”Cloud  Build  configuration file (yaml or json)” and remain other settings to the default and set "Cloud build configuration file" to **/devops/Cloudbuld.yaml**

6. set <your-project-id> in Cloudbuild.yaml, commit and push the project to the repository.
