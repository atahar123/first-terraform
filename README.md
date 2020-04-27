# Terraform

- Terraform is an Orchestration Tool, that is part of IaC.

- IaC gets sent to IaaS, which reads the IaC and makes the infrastructure.

- Chef and Packer are more on the side of Config Management and create immutable AMI's.

- Terraform Orchestrates the creation of networks and complex systems and deploys AMI's.

- An AMI is a blueprint (snapshot) of an instance:
  - The operating system
  - Data and storage
  - All the packages and exact state of a machine when AMI was created


## Prerequisites
- Terraform
- An AMI that's already running
- Your own .pem key

### *NOTE*
- Before going through with this, please make sure you have fulfilled the requirements of the following GitHub repo: https://github.com/atahar123/packer-terraform

- On ```main.tf``` inside app_tier, please add your .pem key with its correct destination.

# To run the Terraform:
Go to the directory of where you cloned the repo and type in the following:
```
terraform init
```
```
terraform plan
```
```
terraform apply
```

- Doing these commands will create and run your EC2 instance, whilst automatically running the app.

- To test that it has worked, go to your instance on AWS EC2, get the public IP address and paste it into your browser, you should see the running app.
