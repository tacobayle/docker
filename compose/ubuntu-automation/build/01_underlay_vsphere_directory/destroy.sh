#!/bin/bash
jsonFile="/etc/config/variables.json"
cd /build/01_underlay_vsphere_directory
terraform init
terraform destroy -auto-approve -var-file=$jsonFile
rm -fr terraform.tfstate .terraform.lock.hcl .terraform