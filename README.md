# kamma-whoami-app

# How it works ?

This GitHub repository contains the necessary files and Dockerfile to build the whoami image. If a commit is made in this repository, GitHub actions will trigger a pipeline and start building the docker image. The pipeline will run relevant test cases and the docker image will be stored in AWS ECR with a relevant tag.

Once the image is stored in AWS ECR the pipeline will allow the application to be automatically deployed to the Kubernetes cluster. Use this guide to setup the infrastructure before attempting to make a change to the repository and deploying the web application. 

# Note before starting 

The root account is not used for deploying the infrastructure as this is not safe. Therefore, I have manually created myself an IAM user called `manishvadgama` from the root account which is attached to a role called `AdminRole` for minimal permissions. This allows us to have a AWS user account called `manishvadgama` to work with.  The user account `manishvadgama` will also have a key pair created manually required for logging into an EC2 instance at a later stage.

Also to note for security reasons when building the EC2 image (from fresh) the public DNS name will change, so the GitHub Action secrets SSH_HOST also needs to be changed. 

# Instructions

Please follow step by step ...

(1) Clone the repo `kamma-whoami-app` to the local workstation


(2) `cd tfmodules/1-terraform-bootstrap`

- When we apply this first terraform module, the role `AdminRole` is assumed. This will create a `terraform_bootstrap_role` IAM role with minimal permissions to deploy an S3 bucket for terraform state in the AWS user account for `manishvadgama`.

(3) `cd tfmodules/2-terraform-create-backend`

- When we apply this module it enables us to assumerole using the `terraform_bootstrap_role` which is created in the previous step. This is will create a terraform state bucket for storing our terraform S3 state, which will be used in the next set of steps when deploying important resources for the application.

(4) `cd tfmodules/3-deployment-role`

- When we apply this module it enables us to assumerole using the `terraform_bootstrap_role` which is created in step 2. This modules deploys an IAM role called`deployment_role`, which has attached policies and permissions. This is the most important role going forward as it gives us the permissions to deploy the required AWS services to deploy the web application. Any other modules to build AWS services would assume the `deployment_role`.

(5) `cd tfmodules/4-build-k8s-environment`

- When we apply this module it enables us to assumerole using the `deployment_role` which is created in step 4. This module builds the AWS services such as ECR, VPC, EC2 Instance (runs k8s) required for deploying the web application.

(6) Make a commit inside this repository and GitHub actions pipeline will be triggered. Check the `Actions` tab in this repository to view the pipeline in action. 

(7) Once the pipeline has run the relevant tests, login to the AWS web console and check that the docker container built has been pushed to the AWS ECR repository. We are now ready to start deploying the web application to the k8s cluster running on the EC2 instance.

(8) `ssh -i "<key-pem>" ec2-user@<dns-address>`

- Login into the EC2 Instance

(9) `minikube start --vm-driver=docker`

- Create the k8s minikube cluster. Once the cluster is up and running you are ready to deploy the web application to the k8s cluster, please visit the `kamma-k8-manifest-files` repository for the next set of instructions.
