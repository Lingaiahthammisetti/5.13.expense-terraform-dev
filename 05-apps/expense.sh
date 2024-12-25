#!/bin/bash

# By default, user data will get sudo access.
dnf install ansible -y
cd /tmp
#git clone https://github.com/linga-daws-78s/expense-ansible-roles-3.git

git clone https://github.com/Lingaiahthammisetti/4.10.expense-ansible-roles-tf.git
cd 4.10.expense-ansible-roles-tf
ansible-playbook main.yaml -e component=backend -e login_password=EExpenseApp@1
ansible-playbook main.yaml -e component=frontend



