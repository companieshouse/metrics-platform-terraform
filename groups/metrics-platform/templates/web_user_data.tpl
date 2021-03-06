#!/bin/bash
# Redirect the user-data output to the console logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

/usr/local/bin/ansible-playbook /root/deployment.yml -e '${ANSIBLE_INPUTS}'
