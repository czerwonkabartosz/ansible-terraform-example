#!/usr/bin/env bash
set -e

if [ "$#" -lt 4 ]; then
  echo "You must pass at least 4 arguments"
  echo "ansible_runner.sh <PRIVATE_KEY_PATH> <TERRAFORM_MODULE_PATH> <TERRAFORM_WORKSPACE> <ANSIBLE_PLAYBOOK_PATH>"
  exit 1
fi

private_key_path=$1
terraform_module_path=$2
terraform_workspace=$3
ansible_playbook_path=$4

temp_dir=$(mktemp -d)

terraform_state_path="${temp_dir}/terraform.tfstate"

cd ${terraform_module_path}

terraform workspace select ${terraform_workspace}
terraform state pull > ${terraform_state_path}

cd - > /dev/null 2>&1

export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_SSH_ARGS="-o IdentitiesOnly=yes"
export TF_STATE=${terraform_state_path}

ansible-playbook --inventory-file=$(which terraform-inventory) --private-key ${private_key_path} -e 'ansible_python_interpreter=/usr/bin/python3' ${ansible_playbook_path}

rm -r ${temp_dir}
