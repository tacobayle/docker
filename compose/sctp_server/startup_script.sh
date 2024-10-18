#!/usr/bin/env bash
ifPrimary=$(/sbin/ip route | grep default | sed -e 's/^.*dev.//' -e 's/.proto.*//')
ip=$(/sbin/ip address show dev $ifPrimary | grep -v inet6 | grep inet | awk '{print $2}' | cut -d'/' -f1)
echo "starting SCTP server listening on $ip"
cd sctp
#while true ; do python sample_server.py $ip 3868 ; sleep 1000000000000 ; done
python sample_server.py $ip 3868