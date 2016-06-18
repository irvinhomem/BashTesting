#!/bin/bash

# Make sure that config.sh is executable
#chmod u+x config.sh

# Get variables from config.sh
source config.sh
echo "--"
echo "### Hopefully this is running on the CLIENT side ! ###"
echo "Tun Server: " ${tun_server}

# Run the Tunnel client commands

#Fix the routing
# 1. Add a route to the DNS server through the normal ethernet default gateway

# 2. Remove the current default gateway (to make sure that all traffic goes through the tunnel interface)

# 3. Add the tunnel interface as the default gateway

# Ping google.com to see if there is communication happening through the tunnel (watch the response on the server side)
