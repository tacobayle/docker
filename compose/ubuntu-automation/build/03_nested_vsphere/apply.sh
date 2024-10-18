#!/bin/bash
jsonFile="/root/nested_vsphere.json"
source /build/bash/tf_init_apply.sh
#
# Build of a folder on the underlay infrastructure
#
tf_init_apply "Build of the nested ESXi/vCenter infrastructure - This should take less than 45 minutes" /build/03_nested_vsphere /build/log/03.stdout /build/log/03.stderr $jsonFile