#!/bin/bash
jsonFile="/root/external_gw.json"
source /build/bash/tf_init_apply.sh
#
# Build of an external GW server on the underlay infrastructure
#
tf_init_apply "Build of an external GW server on the underlay infrastructure - This should take less than 10 minutes" /build/02_external_gateway /build/log/02.stdout /build/log/02.stderr $jsonFile