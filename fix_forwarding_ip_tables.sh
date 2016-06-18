#!/bin/bash

# Make sure that config.sh is "executable" by running
#chmod u+x ./config.sh
# Get/initialize/run declared variables from config.sh
source config.sh
#. ./config.sh

echo "This is for the SERVER side !"

# Fix IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Check that the ip_forward flag has been set
cat /proc/sys/net/ipv4/ip_forward

# Fix iptables rules
# Get the name of the ethernet interface
#cat /proc/net/dev

# Check the name of the interface:
echo "Ethernet Interface: " ${eth_if}

# Run iptables rules
iptables -t nat -A POSTROUTING -o ${eth_if} -j MASQUERADE
iptables -A FORWARD -i ${eth_if} -o dns0 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i dns0 -o ${eth_if} -j ACCEPT
