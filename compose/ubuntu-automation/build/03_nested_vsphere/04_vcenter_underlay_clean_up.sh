#!/bin/bash
#
jsonFile="/root/nested_vsphere.json"
#
export GOVC_DATACENTER=$(jq -r .vcenter_underlay.dc $jsonFile)
export GOVC_USERNAME=$(echo $TF_VAR_vsphere_underlay_username)
export GOVC_PASSWORD=$(echo $TF_VAR_vsphere_underlay_password)
export GOVC_URL=$(jq -r .vcenter_underlay.server $jsonFile)
export GOVC_INSECURE=true
export GOVC_DATASTORE=$(jq -r .vcenter_underlay.datastore $jsonFile)
count=$(jq -c -r '.vcenter_underlay.networks.vsphere.management.esxi_ips | length' $jsonFile)
iso_location=$(jq -r .iso_location $jsonFile)
#
echo ""
echo "++++++++++++++++++++++++++++++++"
echo "Cleaning Datastore"
for esx in $(seq 0 $(expr $count - 1))
do
  echo "+++++++++++++++++++"
  echo "Removing isos/$(basename $iso_location)$esx.iso"
  govc datastore.rm "isos/$(basename $iso_location)$esx.iso"
done
