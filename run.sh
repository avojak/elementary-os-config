#!/bin/bash

set -e

#if [ "$EUID" -ne 0 ]; then
#  echo "Must run as root!"
#  exit 1
#fi

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -h|--help)
      HELP=1
      shift
      ;;
    --vm-mode)
      VM_MODE=1
      shift
      ;;
    *)
      HELP=0
      VM_MODE=0
      shift
      ;;
  esac
done

if [[ "$HELP" -eq 1 ]]; then
  echo "usage: ./run.sh [--vm-mode]"
  exit 0
fi

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

if [[ "$VM_MODE" -eq 1 ]]; then
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
