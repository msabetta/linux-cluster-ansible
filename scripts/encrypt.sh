#!/bin/bash
password_string="admin"
ansible-vault encrypt vault/secrets.yml --vault-password-file <(echo "${password_string}")
