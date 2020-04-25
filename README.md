# Terraform

- Terraform is an Orchestration Tool, that is part of IaaS.

- Chef and Packer are more on the side of Config Management and create immutable AMI's.

- Terraform Orchestrates the creation of networks and complex systems and deploys AMI's.

- An AMI is a blueprint (snapshot) of an instance:
  - The operating system
  - Data and storage
  - All the packages and exact state of a machine when AMI was created



terraform plan
terraform apply
terraform plan -var 'name=bob' <changes variable



nodejs seeds/seed.js


data "template_file" "init" {
  template = "${file("./templates/init.tpl")}"
}

#!/bin/bash

cd /home/ubuntu/app
sudo npm install
sudo chown -R 1000:1000 "/home/ubuntu/.npm"
cd seeds
node seeds.js
cd ..
npm start
