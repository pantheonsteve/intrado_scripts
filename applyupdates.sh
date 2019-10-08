#!/bin/bash
#example command: ./applyupdates.sh <tag> <environment>

# Exit on error
set -e

# login to terminus
terminus auth:login --machine-token=UuXuPBy6NlMovqCIXsvLEbnyYM3Sqp9nIpETZlX9BuXSu

# Stash org UUID
ORG_UUID="1b50534e-d6d6-458a-9095-878e32b52a33"

# TAG - argument 1
TAG="Updates Available"

# Environment - argument 2
ENV='dev'

# Stash list of all Pantheon sites in the org with the tag "Updates Available"
PANTHEON_SITES="$(terminus org:site:list -n ${ORG_UUID} --tag="${TAG}" --field=Name)"

#Loop over the site names
while read -r PANTHEON_SITE_NAME; do

	#clear caches for upstream updates - required to see if an upstream update is available to apply
	terminus site:upstream:clear-cache ${PANTHEON_SITE_NAME}

done <<< "$PANTHEON_SITES"

#Loop over the site names
while read -r PANTHEON_SITE_NAME; do

	#Check Update Status for Upstream updates - is there an update available?
	STATUS=$(terminus upstream:updates:status ${PANTHEON_SITE_NAME}.${ENV})

	#If there are updates available, apply them
	if [[ ${STATUS} = "outdated" ]]
	then
		terminus upstream:updates:apply ${PANTHEON_SITE_NAME}.${ENV}
		terminus tag:remove ${PANTHEON_SITE_NAME} ${ORG_UUID} ${TAG}
		terminus tag:add ${PANTHEON_SITE_NAME} ${ORG_UUID} "No Updates"
		echo 'Updates applied to '${PANTHEON_SITE_NAME}
	else
		echo 'no updates available for '${PANTHEON_SITE_NAME}
	fi

done <<< "$PANTHEON_SITES"
