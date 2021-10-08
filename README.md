# `Flugel.it Challenge`

## Purpose

The purpose of this document is to describe the steps to run and test the application and the deploy infrastructure.

# Initial Deploy Setup

### Prerequisites

- You must have installed:

    - `Python` (version >= 3.7)
    - `Terraform` (version >= 0.14.9)
    - `Packer` (version 1.7.6)
    - `Go` (version 1.17.1)

- You must have an AWS account with credentials configured and properly stored:

    - `AWS_ACCESS_KEY`
    - `AWS_SECRET_ACCESS_KEY`

## Environment Variables

You must create the following files locally and fill its values:

PS: These files will contain environment variables for specific scenarios.

**_.env_** (for Python)

```
AWS_ACCESS_KEY=
AWS_SECRET_KEY=
AWS_REGION=
```

**_deploy/terraform.tfvars_** (for Terraform)

```
aws_access_key = ""
aws_secret_key = ""
aws_region     = ""
default_vpc_id = ""
subnet_id      = ""
```

**_deploy/packer/env.pkrvars.hcl_** (for Packer)

```
aws_access_key = ""
aws_secret_key = ""
aws_region     = ""
```

#### Environment Variables Values Explained

##### aws_access_key

- AWS public credential

##### aws_secret_key

- AWS private credential

##### aws_region

- AWS region where the resources will be deployed
- Example Value: `us-east-1` 

##### default_vpc_id

- The ID of your AWS account default VPC
- Example Value: `vpc-03c2904d9ca8ebaaf`

##### subnet_id

- ID of a subnet of the AWS default VPC
- Example Value: `subnet-0bc26812d38636800`

## Systemd service file - Unit

In order to be able to execute the API in an EC2 instance, keeping it alive and available in case of instance reboot, you will need the following file too:

**_flugel-app.service_**

```
[Unit]
Description=HTTP Service by FastAPI
After=network.target
[Service]
User=ec2-user
Type=simple
WorkingDirectory=/home/ec2-user/fastapi
ExecStart=/usr/bin/python3 /home/ec2-user/fastapi/app/server.py
Restart=always
RestartSec=500ms
StartLimitInterval=0
[Install]
WantedBy=multi-user.target
```

This file will be copied to the server during the Packer build process. Probably you will need to change some of these parameters values such as: **`User`**, **`WorkingDirectory`** and **`ExecStart`**. This is because these parameters are related directly to the server (user name and paths).

# Deploy

- Run the following command: `. ./setup.sh`
- It will create a custom AMI (AWS) using Packer and then it will execute Terraform apply to create a EC2 instance based on this AMI, among other resources (Bucket, SG etc).
- At the end of the execution of these commands, you can get the **EC2 public IP** as a **Terraform output**. You must use it to access the API this way:

    - Application root route: **`http://<ec2_public_ip>:8000`**
    - Get the EC2 instance tags created on deploy: **`http://<ec2_public_ip>:8000/tags/{instance_id}`**
    - Shutdown server (Stop EC2 instance): **`http://<ec2_public_ip>:8000/shutdown/{instance_id}`**

- The route parameter `instance_id` can be obtained in **Terraform output** too.

# Test

- To validate Terraform template, run these following commands: `cd deploy/test && go test -v`
- It will execute a validation of the tags of the AWS resources created using Go/Terratest.
- If there are any problems related to outdated Go dependencies, try to run this command within **_test_** folder: `go mod tidy`