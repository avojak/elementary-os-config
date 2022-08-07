#!/bin/bash

set -e

# Detect running in a virtual machine
vm_mode=$(hostnamectl | grep Virtualization)
vm_mode=$?

# Get these variables from the system rather than setting in Ansible variables
user_name=$(whoami)
user_group=$user_name
user_full_name=$(getent passwd "$user_name" | cut -d ':' -f 5 | cut -d ',' -f 1)
hostname=$(hostname)
ansible_extra_args="user_name=$user_name user_group=$user_group user_full_name=$user_full_name hostname=$hostname"

# Install Ansible
sudo apt install -y ansible

# Install Ansible Galaxy roles
ansible-galaxy install -r ansible/requirements.yml

if [[ "$vm_mode" -eq 0 ]]; then
  echo "Running in VM mode..."
  ansible-playbook ansible/vm-playbook.yml \
      -i ansible/hosts \
      -e "$ansible_extra_args"
else
  echo "Running in non-VM mode..."
  ansible-playbook ansible/playbook.yml \
      -i ansible/hosts \
      -e "$ansible_extra_args"
fi

if [[ "$?" -eq 0 ]]; then
  neofetch
fi
