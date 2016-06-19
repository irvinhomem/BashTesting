#!/bin/bash

# Make sure that config.sh is executable
#chmod u+x config.sh

# Get variables from config.sh
source config.sh
echo "--"
echo "### Hopefully this is running on the CLIENT side ! ###"
echo "Tun Server: " ${tun_server}

# Run the Tunnel client commands
#   Needs to run as sudo
iodine -P ${passwd} ${tun_domain}

#Fix the routing
# 1. Add a route to the DNS server through the normal ethernet default gateway
#   Needs to run as sudo
route add -host ${local_dns} gw ${def_gw}
# 2. Remove the current default gateway (to make sure that all traffic goes through the tunnel interface)
#   Needs to run as sudo
route del default
# 3. Add the tunnel interface as the default gateway
#   Needs to run as sudo
route add default dev ${dns_tun_if} gw ${inside_tun_server}

# TEST
echo "Checking if tunnel has been set up: ..."
# Ping tunnel server end to see if tunnel is working
ping -c 2 ${inside_tun_server} ; echo $?
# Ping google.com to see if there is communication happening through the tunnel (watch the response on the server side)
ping -c 4 google.com ; echo $?
