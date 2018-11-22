#!/bin/bash
# Using debian image so BASH shell - will need changing for smaller images

# INSTALL_URL
# typically https://releases.userify.com/dist/userify-pro-server.gz
# or https://releases.userify.com/dist/userify-enterprise-server.gz
neededvars=" INSTALL_URL "

# Check which vars are missing
set -e
for var in ${neededvars}
do
  value=$(eval echo \$$var)
  if [[ x${value} == x'' ]]
  then
    missing="\"$var\",$missing"
  fi
done
missing=$( echo "${missing}" | rev | cut -c 2- | rev )

# Print missing variables or start
if [[ x${missing} == x'' ]]
then
  STARTED_ON=$(date '+%Y-%m-%d %H:%M:%S')
  neededvars="STARTED_ON ${neededvars}"
else
  echo "{\"MISSING_ENVIRONMENT_VARIABLES\":[${missing}]}" >&2
  exit 1
fi

# list variables for the
visiblevars=" STARTED_ON "

# build the JSON healthcheck loadbalancer
contents=$( for var in ${visiblevars} ; do echo "\"${var}\":\"$(eval echo \$$var)\"," ; done | tr -d '\n' )
jsoncontents="{${contents%?}}"
echo "STARTING_CONTAINER=${jsoncontents}"

# download the latest application version
curl -# "${INSTALL_URL}" | gunzip > userify-server && chmod +x userify-server

# start container threads
./userify-start
redis-server
