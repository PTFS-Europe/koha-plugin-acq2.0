#!/usr/bin/env bash

RED="\033[0;31m"
NC="\033[0m" # No colour
GREEN="\033[0;32m"
YELLOW="\033[1;33m"

echo "Creating and releasing .kpz file"

FILENAME=$(node checkVersionNumber.js filename)
FILE=./${FILENAME}

if test -f "$FILE"; then
    echo "Plugin .kpz file already exists, previous version deleted"
    rm -r "$FILE"
fi
echo "Creating new .kpz file"
zip -r "$FILE" Koha/

NEW_VERSION=$(node checkVersionNumber.js version)

if [ "$NEW_VERSION" = "No plugin file found" ]; then
    echo -e "${RED}No plugin file could be identified, have you created one?"
    echo -e "A plugin file must contain "use base qw\(Koha::Plugins::Base\);"${NC}"
    exit
elif [ "$NEW_VERSION" = "No version found" ]; then
    echo -e "${RED}No version could be identified, does your plugin file include one?"
    echo -e "A plugin file must contain "our \$VERSION = "version here";"${NC}"
    exit
else
    NEW_VERSION_NUMBER=${NEW_VERSION:1}
fi

PREVIOUS_VERSION=$(git log --pretty=oneline | grep -m 1 -o "v[0-9.]\{1,6\}")
if [ -z "$PREVIOUS_VERSION" ]; then
    echo -e "${YELLOW}No previous version found. Assuming this is the first release.${NC}"
    PREVIOUS_VERSION_NUMBER="v0.0.0" # Assuming 0 as the initial version for comparison
else
    PREVIOUS_VERSION_NUMBER=${PREVIOUS_VERSION:1}
fi
echo -e "Previous version: $PREVIOUS_VERSION"
echo -e "New version: $NEW_VERSION"

# Comparing versions
VERSION_COMPARISON=$(echo -e "$PREVIOUS_VERSION_NUMBER\n$NEW_VERSION_NUMBER" | sort -V | head -n 1)
echo -e "Version comparison: $VERSION_COMPARISON"

if [ "$VERSION_COMPARISON" != "$PREVIOUS_VERSION_NUMBER" ]; then
    echo -e "${GREEN}Version has been updated from $PREVIOUS_VERSION_NUMBER to $NEW_VERSION_NUMBER - checking remotes and starting upload${NC}"

    REMOTES=$(git remote -v)
    VALID_REMOTE=$(node checkRemotes.js check $REMOTES)

    if [ "$VALID_REMOTE" = "No valid remotes" ]; then
        echo -e "${RED}You have not set a git remote, please set one to push${NC}"
        exit
    elif [ "$VALID_REMOTE" = "Multiple remotes available" ]; then
        REMOTE_LIST=$(node checkRemotes.js provide $REMOTES)
        echo -e "${RED}Multiple git remotes identified, which one would you like to select?${NC}\n"
        PS3="Select a number:"
        select REMOTE in $REMOTE_LIST
        do
            echo "Selected remote: $REMOTE\n"
            break
        done
        VALID_REMOTE=$(node checkRemotes.js validate $REMOTE $REMOTES)
    fi

    git add .
    git commit -m "$NEW_VERSION"
    git tag "$NEW_VERSION"
    git push $VALID_REMOTE
    echo -e "${GREEN}Plugin has been pushed to Github and a release is being generated${NC}"
else
    echo -e "${RED}WARNING: The Plugin version needs to be updated - please check the .pm file and update the version${NC}"
fi
