#!/usr/bin/env bash
ifPrimary=$(/sbin/ip route | grep default | sed -e 's/^.*dev.//' -e 's/.proto.*//')
ip=$(/sbin/ip address show dev $ifPrimary | grep -v inet6 | grep inet | awk '{print $2}' | cut -d'/' -f1)
echo 'SCTP client IP is $ip'
#
# cd sctp ; while true;do python sample_client.py 172.17.0.2 3868;done
#
