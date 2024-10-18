#!/bin/bash
git clone https://github.com/tacobayle/nested-vsphere -b vsphere8
ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
kopf run /nested-vsphere/vsphere.py --verbose
#while true ; do sleep 3600 ; done