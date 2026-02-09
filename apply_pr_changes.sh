#!/bin/bash

# Define the new version
NEW_VERSION="1.6.3"

# Update version in all relevant files
sed -i "s/UPDATER_VERSION=\"1.6.2\"/UPDATER_VERSION=\"$NEW_VERSION\"/g" \
    antigravity-update.sh \
    linux/antigravity-update.sh \
    docker/antigravity-docker-update.sh \
    "Antigravity Updater.app/Contents/Resources/antigravity-update.sh"

# 1. Localize variable scope in Linux updater
sed -i 's/RELEASE_DATA=\$(printf/local RELEASE_DATA=\$(printf/g' linux/antigravity-update.sh
sed -i 's/LATEST_VERSION=\$(echo/local LATEST_VERSION=\$(echo/g' linux/antigravity-update.sh
sed -i 's/RELEASE_BODY=\$(echo/local RELEASE_BODY=\$(echo/g' linux/antigravity-update.sh

# 2. Localize variable scope in Docker updater
sed -i 's/RELEASE_DATA=\$(printf/local RELEASE_DATA=\$(printf/g' docker/antigravity-docker-update.sh
sed -i 's/LATEST_RELEASE_TAG=\$(echo/local LATEST_RELEASE_TAG=\$(echo/g' docker/antigravity-docker-update.sh
sed -i 's/LATEST_RELEASE_BODY=\$(echo/local LATEST_RELEASE_BODY=\$(echo/g' docker/antigravity-docker-update.sh

# 3. Apply the 'no-v' fix to Docker updater as requested
# The original code was: print(data.get('tag_name') or '');
# The requested change is: print((data.get('tag_name') or '').lstrip('v'));
# This matches what we did for macOS/Linux but specifically requested for Docker too.
sed -i "s/print(data.get('tag_name') or '');/print((data.get('tag_name') or '').lstrip('v'));/g" docker/antigravity-docker-update.sh

# 4. Remove unused 'shlex' imports
# We are no longer using shlex.quote, so we can remove the import.
sed -i 's/import sys, json, shlex/import sys, json/g' \
    antigravity-update.sh \
    linux/antigravity-update.sh \
    docker/antigravity-docker-update.sh

# Wait, the new code doesn't have shlex imported, I might have already used 'import sys, json' in my previous steps.
# Let's verify.
