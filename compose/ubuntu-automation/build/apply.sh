#!/bin/bash
/bin/bash /build/00_pre_check/00.sh
#if [ $? -ne 0 ] ; then exit 1 ; fi
/bin/bash /build/00_pre_check/01.sh
#if [ $? -ne 0 ] ; then exit 1 ; fi
/bin/bash /build/00_pre_check/02.sh
#if [ $? -ne 0 ] ; then exit 1 ; fi
/bin/bash /build/00_pre_check/03.sh
#if [ $? -ne 0 ] ; then exit 1 ; fi
/bin/bash /build/01_underlay_vsphere_directory/apply.sh
#if [ $? -ne 0 ] ; then exit 1 ; fi
/bin/bash /build/02_external_gateway/apply.sh
#if [ $? -ne 0 ] ; then exit 1 ; fi
/bin/bash /build/03_nested_vsphere/apply.sh
#if [ $? -ne 0 ] ; then exit 1 ; fi
while true ; do sleep 3600 ; done
