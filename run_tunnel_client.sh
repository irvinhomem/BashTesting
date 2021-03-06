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

# Delay commands for fixing the routing so that the interfaces are set up and things don't fail
echo "Delaying for 10 seconds as interfaces get set up ..."
sleep 10

echo "========================"
echo "PING the other side of the tunnel ...10.0.0.1 Checking if tunnel has been set up: ... "
# Ping tunnel server end to see if tunnel is working
ping -c 2 ${inside_tun_server} ; echo $?

echo "========================"

if ping -c 1 ${inside_tun_server} &> /dev/null
then
  #Check if the "dns0" interface has come up
  for net_if in $(ls -1 /sys/class/net) ;do
    if [[ ${net_if} == *"dns"* ]]   #Check if it contains the string "dns"
    then
      echo "DNS Tunnel interface created"
      # Fix the routing
      # 1. Add a route to the DNS server through the normal ethernet default gateway
      #   Needs to run as sudo
      route add -host ${local_dns} gw ${def_gw}
      # 2. Remove the current default gateway (to make sure that all traffic goes through the tunnel interface)
      #   Needs to run as sudo

      sleep 5
      route del default
      # 3. Add the tunnel interface as the default gateway
      #   Needs to run as sudo

      sleep 20
      route add default dev ${dns_tun_if} gw ${inside_tun_server}

      echo "Delay for 10 sec ... waiting for routing table to be updated correctly"
      sleep 10

      # Show routing table
      route

      # TEST
      echo "============================"
      echo "Testing PING to Google"
      # Ping google.com to see if there is communication happening through the tunnel (watch the response on the server side)
      ping -c 4 google.com ; echo $?
      echo "============================"
    else
      echo ${net_if}
      #echo "Tunnel Interface possibly not created yet..."
    fi
  done
else
  echo "Ping to " ${inside_tun_server} ": FAILED! ..."
fi
