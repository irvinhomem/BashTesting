#!/bin/bash

# Make sure that config.sh is executable
#chmod u+x config.sh

# Get variables from config.sh
source config.sh
echo "--"
echo "### Hopefully this is running on the SERVER side ! ###"

# Run tunnel server commands
iodined -c -D ${inside_tun_server} ${tun_domain}
