#!/bin/bash
jsonFile="/root/external_gw.json"
cd /build/02_external_gateway
terraform init
terraform destroy -auto-approve -var-file=$jsonFile
rm -fr terraform.tfstate .terraform.lock.hcl .terraform