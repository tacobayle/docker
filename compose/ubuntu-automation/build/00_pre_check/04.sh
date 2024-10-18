#!/bin/bash
#
jsonFile="/etc/config/variables.json"
localJsonFile="/build/02_external_gateway/variables.json"
#
IFS=$'\n'
#
echo "==> Creating /root/nsx.json file..."
rm -f /root/external_gw.json
nsx_json=$(jq -c -r . $jsonFile | jq .)
#
echo "   +++ Adding Networks MTU details"
networks_details=$(jq -c -r .networks $localJsonFile)
nsx_json=$(echo $external_gw_json | jq '. += {"networks": '$(echo $networks_details)'}')
#
echo $nsx_json | jq . | tee /root/nsx.json > /dev/null
#