#!/bin/bash
#
jsonFile="/root/nested_vsphere.json"
#
vcenter_iso_path=$(jq -r .vcenter_iso_path $jsonFile)
iso_mount_location="/tmp/vcenter_cdrom_mount"
iso_tmp_location="/tmp/vcenter_cdrom"
#
xorriso -ecma119_map lowercase -osirrox on -indev $vcenter_iso_path -extract / $iso_mount_location
#
echo ""
echo "++++++++++++++++++++++++++++++++"
echo "Copying JSON template file to template directory"
cp -r $iso_mount_location/$(jq -r .json_config_file $jsonFile) /build/03_nested_vsphere/templates/
#
echo ""
echo "++++++++++++++++++++++++++++++++"
echo "Copying source vCenter ISO to temporary folder $iso_tmp_location"
rm -fr $iso_tmp_location
mkdir -p $iso_tmp_location
cp -r $iso_mount_location/* $iso_tmp_location
#
echo ""
echo "++++++++++++++++++++++++++++++++"
echo "unmounting vCenter ISO file"
rm -fr $iso_mount_location
#
echo ""
echo "++++++++++++++++++++++++++++++++"
echo "Building template file"
template_file_location="/build/03_nested_vsphere/templates/$(basename $(jq -r .json_config_file $jsonFile))"
contents="$(jq '.new_vcsa.esxi.hostname = "'$(jq -r .vcenter.esxi.basename $jsonFile)'1.'$(jq -r .external_gw.bind.domain $jsonFile)'" |
         .new_vcsa.esxi.username = "root" |
         .new_vcsa.esxi.password = "'$TF_VAR_nested_esxi_root_password'" |
         .new_vcsa.esxi.VCSA_cluster.datacenter = "'$(jq -r .vcenter.datacenter $jsonFile)'" |
         .new_vcsa.esxi.VCSA_cluster.cluster = "'$(jq -r .vcenter.cluster $jsonFile)'" |
         .new_vcsa.esxi.VCSA_cluster.disks_for_vsan.cache_disk[0] = "'$(jq -r .cache_disk $jsonFile)'" |
         .new_vcsa.esxi.VCSA_cluster.disks_for_vsan.capacity_disk[0] = "'$(jq -r .capacity_disk $jsonFile)'" |
         .new_vcsa.esxi.VCSA_cluster.enable_vsan_esa = '$(jq -r .enable_vsan_esa $jsonFile)' |
         .new_vcsa.appliance.thin_disk_mode = '$(jq -r .thin_disk_mode $jsonFile)' |
         .new_vcsa.appliance.deployment_option = "'$(jq -r .deployment_option $jsonFile)'" |
         .new_vcsa.appliance.name = "'$(jq -r .vcenter.name $jsonFile)'" |
         .new_vcsa.network.ip = "'$(jq -r .vcenter_underlay.networks.vsphere.management.vcenter_ip $jsonFile)'" |
         .new_vcsa.network.dns_servers[0] = "'$(jq -r .vcenter_underlay.networks.vsphere.management.external_gw_ip $jsonFile)'" |
         .new_vcsa.network.prefix = "'$(jq -r .vcenter_underlay.networks.vsphere.management.prefix $jsonFile)'" |
         .new_vcsa.network.gateway = "'$(jq -r .vcenter_underlay.networks.vsphere.management.gateway $jsonFile)'" |
         .new_vcsa.network.system_name = "'$(jq -r .vcenter.name $jsonFile)'.'$(jq -r .external_gw.bind.domain $jsonFile)'" |
         .new_vcsa.os.password = "'$TF_VAR_vsphere_nested_password'" |
         .new_vcsa.os.ntp_servers = "'$(jq -r .vcenter_underlay.networks.vsphere.management.external_gw_ip $jsonFile)'" |
         .new_vcsa.os.ssh_enable = '$(jq -r .ssh_enable $jsonFile)' |
         .new_vcsa.sso.password = "'$TF_VAR_vsphere_nested_password'" |
         .new_vcsa.sso.domain_name = "'$(jq -r .vcenter.sso.domain_name $jsonFile)'" |
         .ceip.settings.ceip_enabled = '$(jq -r .ceip_enabled $jsonFile)' ' $template_file_location)"
echo "${contents}" | tee /root/vcenter_config.json
#
echo ""
echo "++++++++++++++++++++++++++++++++"
echo "updating local /etc/hosts with vCenter and esxi hosts"
contents=$(cat /etc/hosts | grep -v $(jq -r .vcenter_underlay.networks.vsphere.management.vcenter_ip $jsonFile))
echo "${contents}" | tee /etc/hosts
contents="$(jq -r .vcenter_underlay.networks.vsphere.management.vcenter_ip $jsonFile) $(jq -r .vcenter.name $jsonFile).$(jq -r .external_gw.bind.domain $jsonFile)"
echo "${contents}" | tee -a /etc/hosts
IFS=$'\n'
count=1
for ip in $(cat $jsonFile | jq -c -r .vcenter_underlay.networks.vsphere.management.esxi_ips[])
do
  contents=$(cat /etc/hosts | grep -v $ip)
  echo "${contents}" | tee /etc/hosts
  contents="$ip $(jq -r .vcenter.esxi.basename $jsonFile)$count.$(jq -r .external_gw.bind.domain $jsonFile)"
  echo "${contents}" | tee -a /etc/hosts
  count=$((count+1))
done
#
echo ""
echo "++++++++++++++++++++++++++++++++"
echo "starting vCenter Installation"
$iso_tmp_location/vcsa-cli-installer/lin64/vcsa-deploy install --accept-eula --acknowledge-ceip --no-esx-ssl-verify /root/vcenter_config.json
