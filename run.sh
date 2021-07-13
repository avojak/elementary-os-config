#!/bin/bash

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

# Install Ansible
sudo apt install -y ansible

# Install Ansible Galaxy roles
ansible-galaxy install -r ansible/requirements.yml

if [[ "$VM_MODE" -eq 1 ]]; then
  echo "Running in VM mode..."
  ansible-playbook ansible/vm-playbook.yml -i ansible/hosts
else
  echo "Running in non-VM mode..."
  ansible-playbook ansible/playbook.yml -i ansible/hosts
fi

if [[ "$?" -eq 0 ]]; then
  neofetch
fi
