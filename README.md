# Terraform

- Terraform is an Orchestration Tool, that is part of IaaS.

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

- On ```main.tf```, please change the following lines: 48, 99, and 111 to your name and your .pem key with its correct destination.

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

*NOTE*
After using ```terraform apply```, you will see this loop in your Terminal:
```
aws_instance.app_instance: Still creating... [time elapsed]
```
This means that the app is working.

After you have seen the app working, you can stop this loop by pressing ```ctrl + c```, but do note that your app will also stop working.
