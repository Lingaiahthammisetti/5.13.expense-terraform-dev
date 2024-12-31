#!/bin/bash

# By default, user data will get sudo access.
dnf install ansible -y
cd /tmp
git clone https://github.com/Lingaiahthammisetti/4.10.1.expense-ansible-roles-tf-terraform-dev.git
cd 4.10.1.expense-ansible-roles-tf-terraform-dev
ansible-playbook main.yaml -e component=backend -e login_password=ExpenseApp1
ansible-playbook main.yaml -e component=frontend



