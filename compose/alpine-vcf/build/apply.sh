#!/bin/bash
git clone https://github.com/tacobayle/nested-vcf
cp /etc/config/variables.json /root/variables.json
ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
kopf run /nested-vcf/vcf.py --verbose
#while true ; do sleep 3600 ; done