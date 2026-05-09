#!/bin/bash
ansible-playbook -i inventory/hosts.yml playbooks/site.yml "$@" --vault-password-file .vault_pass