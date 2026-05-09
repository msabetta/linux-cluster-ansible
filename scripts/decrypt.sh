#!/bin/bash
password_string="admin"
ansible-vault decrypt vault/secrets.yml --vault-password-file <(echo "${password_string}")