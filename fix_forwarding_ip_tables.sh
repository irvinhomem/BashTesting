#!/bin/bash

echo "This is for the SERVER side !"

#Fix IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

#Check that the ip_forward flag has been set
cat /proc/sys/net/ipv4/ip_forward

#Fix iptables rules
cat /proc/net/dev
#iptables -t nat -A POSTROUTING -o
