# Ansible with Terraform Example

This repository is a example how using using [Terraform](https://www.terraform.io/) and [Ansible](http://docs.ansible.com/ansible/).

Terraform is using to create immutable EC2 instance on AWS and Ansible to install and configure HAProxy.

## Setup:

1. Install:
    * [Terraform](https://www.terraform.io/)
    * [Terraform Inventory](https://github.com/adammck/terraform-inventory)

## Usage:
Run Terraform:
```
terraform init --backend-config="access_key=XXX" --backend-config="secret_key=YYY"
terraform workspace new dev-env
terraform apply 
```

Run Ansible playbook:
```
sh ansible_runner.sh ~/.ssh/id_rsa terraform/ workspace ansible/haproxy.yml
```


## Development:
It is possible to test Ansible scripts locally with use [Vagrant](https://www.vagrantup.com/).

```
cd ansibble/
ansible-galaxy install -r requirements.yml

vagrant up
```

Or if the machine is running then the Ansible changes can be tested using only

```
vagrant provision
```
