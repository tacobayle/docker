#!/bin/bash
jsonFile="/etc/config/variables.json"
source /build/bash/tf_init_apply.sh
#
# Build of a folder on the underlay infrastructure
#
tf_init_apply "Build of a folder on the underlay infrastructure - This should take less than a minute" /build/01_underlay_vsphere_directory /build/log/01.stdout /build/log/01.stderr $jsonFile
