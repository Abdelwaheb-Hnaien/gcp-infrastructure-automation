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
Templating is a good idea when you would like to create the same resource several times with different parameters.
A best practice when writing IaC is to separate configuration from logic, i.e to group together the infrastructure variables in a **config.yaml** file per environment:

<img src="images/env.png" width="30%"/>

Infrastructure-builder supports __jinja templating__, The step before provisioning is to feed those variables into the main code, next is an example of writing a Storage bucket and a Compute Instance with templating:
<img src="images/templating.png"/>
Templating step will generate the following IaC: <br/><br/> <img src="images/iac.png" width="70%"/>

#### Provisioning :
Provisioning will simply run different Terraform commands (plan, apply) to deploy infrastructure.

Templating and Provioning are embedded together in the following declaration of **Cloudbuild.yaml** within your project :
<img src="images/cloudbuild.png" width="70%"/>

The step supports one of the following argument :<br/>
- __dry-deploy__: Infrastructure_builder will preform templating then terraform **plan**<br/>
- __deploy__: Infrastructure_builder will preform templating then terraform **apply**<br/>
- __clean__: Infrastructure_builder will preform templating then terraform **destroy**<br/>

## How to set up infrastructur builder in my GCP project ?
Before you begin check Dockerfile, there are a number of commented lines (steps) for Infrastructure driven test with Terratest (Go language, check https://terratest.gruntwork.io/ for more information). If you consider developping tests for your infrastructure, uncomment them before building the image.

Notice that after running the following steps infrastructure builder will be created in Container Registery within your project.

1. CHANGE [your-project-id] in cloudbuild.yaml, this should be your GCP project where infrastructure builder will be created.

2. Go to your project and create a repository on Cloud Source Repositories.

3. Create a trigger for the repository you have just created. The trigger should points to a Dockerfile so that Cloudbuild will create the image when you push your code (Don't forget to enable the trigger).

Make sure Cloud Build can push containers to Container registery, the default service account for CloudBuild is Compute Engine service account which has the editor role in your project.. if so, you don't have to change anything.
Then, Infrastructure builder should be available in conatiner registery within your project.

Each time you call the builder in CloudBuild steps, it will inherit permissions from Cloud Build itself, so make sure to grant Cloud build the appropriate access rights to create resources in the destination project.

## Demo :

In this demo we will deploy the following infrastructure :

<img src="images/demo.png" width="30%"/>

A Google storage bucket, and two compute instances, each instance will run a different startup script to install apache web server. The script will also modify index.html so that _instance 1_ will return **Hello from Belgium**, _instance 2_ will return **Hello from London** (based on the geographic location), then group together the two instances in a node pool and create a TCP Load Balancer to route the income trafic to the node pool just created.

1) Make sure infrastructure-builder is available in your project and that Cloud build has sufficient permissions to create resources.

2) Create a Google storage backet to be used as a backend for Terraform

2) Clone this repository : https://github.com/Abdelwaheb-Hnaien/gcp-infrastructure-automation-demo

__Notice__ : all folders are optionals except **DevOps**. It should be in the repository **root** folder and has the following structure:

<img src="images/devops.png" width="40%"/>

**modules** folder (optional): contains resource modules (in case you are writing modular IaC).

Folders in **config/** represents your environments (dev, staging, prod, etc), each folder has a config.yaml file.

If you are devoloping the same Infrastructure for different environments than your config file should be in **config/\<your environment name>**

You tell infrastructure builder about which config file to use by setting he ENV variable in **Cloudbuild.yaml**.

3) Create a repository on Google Cloud Repositories in your project

4) Set up a trigger in cloud build and set ”Cloud Source Repository” as a repository hosting option

5) Select the repository you created in step 3

6) In the trigger settings Select ”Cloud  Build  configuration file (yaml or json)” as a build configuration and remain other settings to the default

7) Set "Cloud build configuration file" to **/devops/Cloudbuld.yaml**

8) Set <your-project-id> in Cloudbuild.yaml, change the backend bucket name in config.yaml

9) Commit and push to the repository created in step 3.

Check Cloud build history, resources should be created successefully :

<img src="images/finish_build.png" width="70%"/>
