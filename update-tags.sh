#!/bin/bash
#example command: ./update-tags.sh
#Removes "Updates Agailable" and "No Updates" tags to reset for the demo

# Exit on error
set -e

# login to terminus
terminus auth:login --machine-token=UuXuPBy6NlMovqCIXsvLEbnyYM3Sqp9nIpETZlX9BuXSu

# Stash org UUID
ORG_UUID="1b50534e-d6d6-458a-9095-878e32b52a33"

# Environment
ENV='dev'

UPDATE_TAG="Updates Available"

CURRENT_TAG="No Updates"

# Stash list of all Pantheon sites in the org
PANTHEON_SITES="$(terminus org:site:list -n ${ORG_UUID} --field=Name)"

# Stash list of all Pantheon sites in the org tagged with "Updates Available"
UPDATE_SITES="$(terminus org:site:list -n ${ORG_UUID} --tag='Updates Available' --field=Name)"

# Stash list of all Pantheon sites in the org
CURRENT_SITES="$(terminus org:site:list -n ${ORG_UUID} --tag='No Updates' --field=Name)"

#Loop over the site names
while read -r UPDATE_SITE_NAME; do

  #stash a list of tags for a particular site
  terminus tag:remove ${UPDATE_SITE_NAME} ${ORG_UUID} "${UPDATE_TAG}"

done <<< "$UPDATE_SITES"

#Loop over the site names
while read -r CURRENT_SITE_NAME; do

  #stash a list of tags for a particular site
  terminus tag:remove ${CURRENT_SITE_NAME} ${ORG_UUID} "${CURRENT_TAG}"

done <<< "$CURRENT_SITES"
