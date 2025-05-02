# Terraform Demo

This Terraform project creates a simple AWS EC2 instance.

## Files

- `main.tf`: EC2 instance configuration
- `variables.tf`: Input variables
- `outputs.tf`: Outputs like instance ID

## Usage

```bash
terraform init
terraform apply


Terraform and Jenkins CI/CD Setup Documentation
Overview
This document explains how to set up Jenkins to run Terraform scripts for provisioning an AWS EC2 instance. We will:

Set up a GitHub repository for Terraform scripts.

Install necessary tools on Jenkins server.

Create and configure the Jenkins pipeline.

Integrate AWS credentials securely with Jenkins.

Run Terraform commands (init, plan, apply).

Prerequisites
Jenkins server set up.

AWS account.

GitHub account with a repository for Terraform code.

AWS IAM user with permissions for EC2, VPC, and other required services.

Terraform installed on Jenkins.

Step 1: Set Up GitHub Repository
Create a new GitHub repository (e.g., terraform-new).

Clone the repository locally:

bash
Copy
Edit
git clone https://github.com/YOUR_USERNAME/terraform-new.git
cd terraform-new
Create the following Terraform files:

main.tf: Contains your AWS resources (e.g., EC2 instance).

variables.tf: Declares variables (optional).

outputs.tf: Outputs of your Terraform deployment (optional).

Example Terraform Files:
main.tf

hcl
Copy
Edit
provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"  # Choose an appropriate AMI ID
  instance_type = "t2.micro"
}
variables.tf (Optional)

hcl
Copy
Edit
variable "region" {
  default = "us-east-2"
}
outputs.tf (Optional)

hcl
Copy
Edit
output "instance_id" {
  value = aws_instance.example.id
}
Step 2: Set Up Jenkins Server
2.1 Install Dependencies on Jenkins
Install Terraform:

bash
Copy
Edit
sudo apt-get install -y wget unzip
wget https://releases.hashicorp.com/terraform/1.11.4/terraform_1.11.4_linux_amd64.zip
unzip terraform_1.11.4_linux_amd64.zip
sudo mv terraform /usr/local/bin/
Install Git:

bash
Copy
Edit
sudo apt-get install git
Install AWS CLI:

Since awscli was not installing directly via apt, you can install it via pip:

bash
Copy
Edit
sudo apt-get install python3-pip
sudo pip3 install awscli
Verify installation:

bash
Copy
Edit
aws --version
Step 3: Set Up AWS Credentials in Jenkins
3.1 Create AWS IAM User
Create an IAM user in AWS with programmatic access (Access Key ID and Secret Access Key).

Attach appropriate policies like AmazonEC2FullAccess.

Save the credentials securely.

3.2 Configure AWS Credentials in Jenkins
Go to Jenkins → Manage Jenkins → Manage Credentials.

Under (global) → Add Credentials:

Kind: Secret text

ID: aws-access-key

Secret: Your AWS Access Key

Repeat for the Secret Access Key.

Step 4: Create a Jenkins Pipeline
4.1 Create a New Pipeline Job
Go to Jenkins Dashboard → New Item.

Name your pipeline (e.g., terraform-ec2), select Pipeline, and click OK.

4.2 Configure the Jenkins Pipeline
In the Pipeline section:

Choose Pipeline script.

Write your Jenkinsfile directly in the script section.

Example Jenkinsfile:

pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        AWS_DEFAULT_REGION    = 'us-east-2'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/YOUR_USERNAME/terraform-new.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=plan.tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve plan.tfplan'
            }
        }
    }

    parameters {
        booleanParam(name: 'APPLY_TERRAFORM', defaultValue: false, description: 'Apply Terraform changes?')
    }
}
Step 5: Run the Jenkins Pipeline
After setting up the pipeline, save and then Build Now.

Jenkins will:

Clone your GitHub repository.

Run terraform init, terraform plan, and terraform apply.

Provision an EC2 instance using the Terraform configuration.

Step 6: Monitor Output and Logs
After running the pipeline, check the Console Output to monitor:

If the Terraform plan and apply were successful.

Any errors or warnings during the process.

Additional Tips
Terraform Plan: Always use terraform plan -out=plan.tfplan for safety in production pipelines.

Automating Terraform Destroy: You can also add a stage for terraform destroy if you want to destroy the resources in a future pipeline run.

Terraform State: Ensure that your Terraform state files (terraform.tfstate) are securely stored, either remotely in S3 or in a backend.

Security: Avoid putting your AWS Access Key directly in the Jenkinsfile. Always use Jenkins credentials.

Conclusion
By following this document, you have successfully:

Created a GitHub repository with Terraform code.

Set up Jenkins to run Terraform commands using a secure pipeline.

Integrated AWS credentials with Jenkins using the built-in credentials manager.

You now have an automated CI/CD pipeline that provisions AWS EC2 instances using Terraform! 🎉

Let me know if you'd like further details or help with additional configurations.








