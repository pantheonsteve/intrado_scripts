#!/bin/bash
#example command: ./new-site.sh <site machine name> "<site label>"

# Exit on error
set -e

# login to terminus
terminus auth:login --machine-token=UuXuPBy6NlMovqCIXsvLEbnyYM3Sqp9nIpETZlX9BuXSu

# Stash org UUID
ORG_UUID="1b50534e-d6d6-458a-9095-878e32b52a33"

# Stash Upstream ID
UPSTREAM_ID="5fbfd38f-a353-4086-b232-2095fa460a7c"

#Create new site
# Site Name
SITE_NAME=$1

#Site Label
SITE_LABEL=$2

Terminus site:create ${SITE_NAME} "${SITE_LABEL}" 5fbfd38f-a353-4086-b232-2095fa460a7c

terminus site:clone ir-starter-site.dev ${SITE_NAME}.dev
