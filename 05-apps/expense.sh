#!/bin/bash

# By default, user data will get sudo access.
dnf install ansible -y
cd /tmp
git clone https://github.com/linga-daws-78s/expense-ansible-roles-3.git
cd expense-ansible-roles-3
ansible-playbook main.yaml -e component=backend -e login_password=ExpenseApp1
ansible-playbook main.yaml -e component=frontend

