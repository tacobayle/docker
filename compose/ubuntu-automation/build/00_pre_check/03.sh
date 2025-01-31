#!/bin/bash
#
source /build/bash/ip.sh
#
jsonFile="/etc/config/variables.json"
localJsonFile="/build/03_nested_vsphere/variables.json"
#
IFS=$'\n'
#
echo ""
echo "==> Creating /root/nested_vsphere.json file..."
rm -f /root/nested_vsphere.json
nested_vsphere_json=$(jq -c -r . $jsonFile | jq .)
#
echo "   +++ Adding boot_cfg_location..."
boot_cfg_location=$(jq -c -r '.boot_cfg_location' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"boot_cfg_location": "'$(echo $boot_cfg_location)'"}')
#
echo "   +++ Adding iso_location..."
iso_location=$(jq -c -r '.iso_location' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"iso_location": "'$(echo $iso_location)'"}')
#
echo "   +++ Adding iso_source_location..."
iso_source_location=$(jq -c -r '.iso_source_location' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"iso_source_location": "'$(echo $iso_source_location)'"}')
#
echo "   +++ Adding vcenter_iso_path..."
vcenter_iso_path=$(jq -c -r '.vcenter_iso_path' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"vcenter_iso_path": "'$(echo $vcenter_iso_path)'"}')
#
echo "   +++ Adding boot_cfg_lines..."
boot_cfg_lines=$(jq -c -r '.boot_cfg_lines' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"boot_cfg_lines": '$(echo $boot_cfg_lines)'}')
#
echo "   +++ Adding bios..."
bios=$(jq -c -r '.bios' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"bios": "'$(echo $bios)'"}')
#
echo "   +++ Adding guest_id..."
guest_id=$(jq -c -r '.guest_id' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"guest_id": "'$(echo $guest_id)'"}')
#
echo "   +++ Adding keyboard_type..."
keyboard_type=$(jq -c -r '.keyboard_type' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"keyboard_type": "'$(echo $keyboard_type)'"}')
#
echo "   +++ Adding wait_for_guest_net_timeout..."
wait_for_guest_net_timeout=$(jq -c -r '.wait_for_guest_net_timeout' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"wait_for_guest_net_timeout": "'$(echo $wait_for_guest_net_timeout)'"}')
#
echo "   +++ Adding nested_hv_enabled..."
nested_hv_enabled=$(jq -c -r '.nested_hv_enabled' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"nested_hv_enabled": "'$(echo $nested_hv_enabled)'"}')
#
echo "   +++ Adding cache_disk..."
cache_disk=$(jq -c -r '.cache_disk' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"cache_disk": "'$(echo $cache_disk)'"}')
#
echo "   +++ Adding capacity_disk..."
capacity_disk=$(jq -c -r '.capacity_disk' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"capacity_disk": "'$(echo $capacity_disk)'"}')
#
echo "   +++ Adding enable_vsan_esa..."
enable_vsan_esa=$(jq -c -r '.enable_vsan_esa' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"enable_vsan_esa": "'$(echo $enable_vsan_esa)'"}')
#
echo "   +++ Adding thin_disk_mode..."
thin_disk_mode=$(jq -c -r '.thin_disk_mode' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"thin_disk_mode": "'$(echo $thin_disk_mode)'"}')
#
echo "   +++ Adding deployment_option..."
deployment_option=$(jq -c -r '.deployment_option' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"deployment_option": "'$(echo $deployment_option)'"}')
#
echo "   +++ Adding ssh_enable..."
ssh_enable=$(jq -c -r '.ssh_enable' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"ssh_enable": "'$(echo $ssh_enable)'"}')
#
echo "   +++ Adding ceip_enabled..."
ceip_enabled=$(jq -c -r '.ceip_enabled' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"ceip_enabled": "'$(echo $ceip_enabled)'"}')
#
echo "   +++ Adding json_config_file..."
json_config_file=$(jq -c -r '.json_config_file' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"json_config_file": "'$(echo $json_config_file)'"}')
#
echo "   +++ Adding networks..."
networks=$(jq -c -r '.networks' $localJsonFile)
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. += {"networks": '$(echo $networks)'}')
#
echo "   +++ Adding prefix for vSphere management network..."
prefix=$(ip_prefix_by_netmask $(jq -c -r '.vcenter_underlay.networks.vsphere.management.netmask' $jsonFile) "   ++++++")
nested_vsphere_json=$(echo $nested_vsphere_json | jq '.vcenter_underlay.networks.vsphere.management += {"prefix": "'$(echo $prefix)'"}')
#
echo "   +++ Adding disk label and disk unit number..."
count=0
new_disks="[]"
for disk in $(jq -c -r .vcenter.esxi.disks[] $jsonFile)
do
  new_disk=$(echo $disk | jq '. += {"label": "'$(echo disk$count)'", "unit_number": "'$(echo $count)'"}')
  new_disks=$(echo $new_disks | jq '. += ['$(echo $new_disk)']')
  ((count++))
done
nested_vsphere_json=$(echo $nested_vsphere_json | jq '. | del (.vcenter.esxi.disks)')
nested_vsphere_json=$(echo $nested_vsphere_json | jq '.vcenter.esxi += {"disks": '$(echo $new_disks)'}')
#
echo $nested_vsphere_json | jq . | tee /root/nested_vsphere.json > /dev/null
#
echo ""
echo "==> Downloading ESXi ISO file"
if [ -s "$(jq -c -r .iso_source_location $localJsonFile)" ]; then echo "   ++++++ ESXi iso file $(jq -c -r .iso_source_location $localJsonFile) is not empty" ; else curl -s -o $(jq -c -r .iso_source_location $localJsonFile) $(jq -c -r .vcenter.esxi.iso_url $jsonFile) ; fi
if [ -s "$(jq -c -r .iso_source_location $localJsonFile)" ]; then echo "   ++++++ ESXi iso file $(jq -c -r .iso_source_location $localJsonFile) is not empty" ; else echo "   ++++++ ESXi iso $(jq -c -r .iso_source_location $localJsonFile) is empty" ; exit 255 ; fi
#
echo ""
echo "==> Downloading vSphere ISO file"
if [ -s "$(jq -c -r .vcenter_iso_path $localJsonFile)" ]; then echo "   ++++++ ESXi iso file $(jq -c -r .vcenter_iso_path $localJsonFile) is not empty" ; else curl -s -o $(jq -c -r .vcenter_iso_path $localJsonFile) $(jq -c -r .vcenter.iso_url $jsonFile) ; fi
if [ -s "$(jq -c -r .vcenter_iso_path $localJsonFile)" ]; then echo "   ++++++ ESXi iso file $(jq -c -r .vcenter_iso_path $localJsonFile) is not empty" ; else echo "   ++++++ vSphere ova $(jq -c -r .vcenter_iso_path $localJsonFile) is empty" ; exit 255 ; fi