#!/bin/bash

# A very jank auto update solution for 1.6-rebuild

logger -t jank-auto-updater "Starting 1.6-rebuild auto update service"

echo "Is there a pending update?"
logger -t jank-auto-updater "Is there a pending update?"
if [ -f /run/rebuild-updated ]; then
    echo "An update is already in progress, waiting until nightly reboot"
    logger -t jank-auto-updater "An update is already in progress, waiting until nightly reboot"
    exit 1
else
    echo "No updates pending, continuing..."
    logger -t jank-auto-updater "No updates pending, continuing..."
fi

echo "Are auto updates enabled?"
logger -t jank-auto-updater "Are auto updates enabled?"
if [ -f /data/data/user-do-not-auto-update ]; then
    echo "Auto update disabled by user, falling out"
    logger -t jank-auto-updater "Auto update disabled by user, falling out"
    exit 1
else
    echo "Auto updates are not disabled, continuing with updating"
    logger -t jank-auto-updater "Auto updates are not disabled, continuing with updating"
fi

echo "Has this build had dev done on it?"
logger -t jank-auto-updater "Has this build had dev done on it?"
if [ -f /anki-devtools ]; then
    echo "Build has been deployed to, not auto updating"
    logger -t jank-auto-updater "Build has been deployed to, not auto updating"
    exit 1
else
    echo "Build is stock, auto updates allowed"
    logger -t jank-auto-updater "Build is stock, auto updates allowed"
fi

# Auto updates are enabled, clear to set some variables
# In alphabetical order too!
BUILDINF="$(cat /build.prop)"
CMDLINE="$(cat /proc/cmdline)"
CURRENT_VERSION=$(getprop ro.anki.version)
DEV_BUILD_ID=d
OSKR_BUILD_ID=oskr
REBUILD_URL="http://modder.my.to:81/otas/1.6-rebuild"
EXTENSION=$(getprop ro.build.id)

echo "Is this an indev or release ota?"
logger -t jank-auto-updater "Is this an indev or release ota?"
if [ -f /etc/rebuild-indev ]; then
    echo "Indev ota detected, downloading from indev stack"
    logger -t jank-auto-updater "Indev ota detected, downloading from indev stack"
    TARGET_VERSION=$(curl $REBUILD_URL/indev/latest)
    INDEV=1
elif [ -f /etc/rebuild-release ]; then
    echo "Release ota detected, downloading from Release stack"
    logger -t jank-auto-updater "Release ota detected, downloading from Release stack"
    TARGET_VERSION=$(curl $REBUILD_URL/release/latest)
    RELEASE=1
else
    echo "Not indev or release, exiting"
    logger -t jank-auto-updater "Not indev or release, exiting"
    exit 1
fi

echo "Checking active slot"
logger -t jank-auto-updater "Checking active slot"
if [[ ${CMDLINE} == *"androidboot.slot_suffix=_b"* ]]; then
	echo "Current slot is b, update will install to a."
    INSTALL_SLOT=a
    logger -t jank-auto-updater "Current slot is b, update will install to a."
else
	echo "Current slot is a, update will install to b."
    INSTALL_SLOT=b
    logger -t jank-auto-updater "Current slot is a, update will install to b."
fi

echo "Getting current firmware version"
logger -t jank-auto-updater "Getting current firmware version"
echo "Current version: $CURRENT_VERSION"
logger -t jank-auto-updater "Current version: $CURRENT_VERSION"

echo "Getting update version"
logger -t jank-auto-updater "Getting update version"
echo "Target update version is $TARGET_VERSION"
logger -t jank-auto-updater "Target update version is $TARGET_VERSION"

echo "OSKR, Dev, or Prod?"
logger -t jank-auto-updater "OSKR, Dev, or Prod?"
if [[ ${EXTENSION} == $CURRENT_VERSION$DEV_BUILD_ID ]]; then
	echo "Build type is dev"
    logger -t jank-auto-updater "Build type is dev"
    CURRENT_BUILD_ID=d
    DEV=1
elif [[ ${EXTENSION} == $CURRENT_VERSION$OSKR_BUILD_ID ]]; then
	echo "Build type is OSKR"
    logger -t jank-auto-updater "Build type is OSKR"
    CURRENT_BUILD_ID=oskr
    OSKR=1
else
	echo "Build type is production"
    logger -t jank-auto-updater "Build type is production"
    CURRENT_BUILD_ID=
    PROD=1
fi

if [[ $CURRENT_VERSION == $TARGET_VERSION ]]; then
    echo "Rebuild up to date, exiting"
    logger -t jank-auto-updater "Rebuild up to date, exiting"
    exit 0
fi

echo "Installing ota update to system slot $INSTALL_SLOT"
logger -t jank-auto-updater "Installing ota update to system slot $INSTALL_SLOT"
if [[ ${DEV} = 1 ]]; then
    if [[ ${INDEV} = 1 ]]; then
        FINAL_REBUILD_URL=$REBUILD_URL/indev/dev/vicos-$TARGET_VERSION$CURRENT_BUILD_ID.ota
        echo "Update URL $FINAL_REBUILD_URL"
        logger -t jank-auto-updater "Update URL $FINAL_REBUILD_URL"
        /sbin/rebuild-update-os $FINAL_REBUILD_URL
    elif [[ ${RELEASE} = 1 ]]; then
        FINAL_REBUILD_URL=$REBUILD_URL/release/dev/vicos-$TARGET_VERSION$CURRENT_BUILD_ID.ota
        echo "Update URL $FINAL_REBUILD_URL"
        logger -t jank-auto-updater "Update URL $FINAL_REBUILD_URL"
        /sbin/rebuild-update-os $FINAL_REBUILD_URL
    fi
elif [[ ${OSKR} = 1 ]]; then
    if [[ ${INDEV} = 1 ]]; then
        FINAL_REBUILD_URL=$REBUILD_URL/indev/oskr/vicos-$TARGET_VERSION$CURRENT_BUILD_ID.ota
        echo "Update URL $FINAL_REBUILD_URL"
        logger -t jank-auto-updater "Update URL $FINAL_REBUILD_URL"
        /sbin/rebuild-update-os $FINAL_REBUILD_URL
    elif [[ ${RELEASE} = 1 ]]; then
        FINAL_REBUILD_URL=$REBUILD_URL/release/oskr/vicos-$TARGET_VERSION$CURRENT_BUILD_ID.ota
        echo "Update URL $FINAL_REBUILD_URL"
        logger -t jank-auto-updater "Update URL $FINAL_REBUILD_URL"
        /sbin/rebuild-update-os $FINAL_REBUILD_URL
    fi
elif [[ ${PROD} = 1 ]]; then
    if [[ ${INDEV} = 1 ]]; then
        FINAL_REBUILD_URL=$REBUILD_URL/indev/prod/vicos-$TARGET_VERSION$CURRENT_BUILD_ID.ota
        echo "Update URL $FINAL_REBUILD_URL"
        logger -t jank-auto-updater "Update URL $FINAL_REBUILD_URL"
        /sbin/rebuild-update-os $FINAL_REBUILD_URL
    elif [[ ${RELEASE} = 1 ]]; then
        FINAL_REBUILD_URL=$REBUILD_URL/release/prod/vicos-$TARGET_VERSION$CURRENT_BUILD_ID.ota
        echo "Update URL $FINAL_REBUILD_URL"
        logger -t jank-auto-updater "Update URL $FINAL_REBUILD_URL"
        /sbin/rebuild-update-os $FINAL_REBUILD_URL
    fi
fi

sync
echo "Update Done"
logger -t jank-auto-updater "Update Done"
exit 0